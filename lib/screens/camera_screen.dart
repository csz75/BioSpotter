import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/identification/col_match.dart';
import '../features/identification/species_suggestion.dart';
import '../l10n/app_localizations.dart';
import 'species_search_screen.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _initializing = true;
  bool _busy = false;

  String? _errorKey;

  double _maxZoom = 1.0;
  double _zoom = 1.0;

  static const _colLangs = ['hun', 'eng', 'deu', 'fra', 'spa', 'ita', 'pol'];

  /// Ez alatt a biztonsági szint alatt nem ajánlunk fel találatot.
  static const _minScoreToSuggest = 40.0;

  /// Ez felett a biztonsági szint felett automatikus azonosításnak számít.
  static const _autoIdentifyScore = 70.0;

  /// Az app nyelvének ISO 639-3 kódja (a GBIF ezt használja).
  String _appColLang() {
    final code = localeController.locale?.languageCode ??
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    switch (code) {
      case 'hu':
        return 'hun';
      case 'en':
        return 'eng';
      case 'de':
        return 'deu';
      case 'fr':
        return 'fra';
      case 'es':
        return 'spa';
      case 'it':
        return 'ita';
      case 'pl':
        return 'pol';
      default:
        return 'eng';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setUpCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _setUpCamera();
    }
  }

  Future<void> _setUpCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorKey = 'noCamera';
          _initializing = false;
        });
        return;
      }
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      double maxZoom = 1.0;
      try {
        maxZoom = await controller.getMaxZoomLevel();
      } catch (_) {
        maxZoom = 1.0;
      }

      if (!mounted) return;
      setState(() {
        _controller = controller;
        _initializing = false;
        _errorKey = null;
        _maxZoom = maxZoom < 1.0 ? 1.0 : maxZoom;
        _zoom = 1.0;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorKey = 'initFailed';
        _initializing = false;
      });
    }
  }

  Future<void> _applyZoom(double value) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final clamped = value.clamp(1.0, _maxZoom);
    setState(() => _zoom = clamped);
    try {
      await controller.setZoomLevel(clamped);
    } catch (_) {}
  }

  Future<Position> _determinePosition() async {
    final l = AppLocalizations.of(context);

    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception(l.locationServiceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw Exception(l.locationPermissionDenied);
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(l.locationPermissionDeniedForever);
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return last;
      throw Exception(l.locationUnavailable);
    }
  }

  /// A GBIF-ből származó hétnyelvű neveket kéri le egy tudományos névre.
  /// A GBIF ugyanazt a taxont több találatban adja vissza, és a népies
  /// nevek szétszórva vannak köztük — ezért az összeset egyesítjük.
  Future<({Map<String, String> names, int? gbifKey})> _fetchVernaculars(
    String scientificName,
  ) async {
    try {
      final matches = await ref
          .read(colSearchServiceProvider)
          .search(query: scientificName, language: 'eng', limit: 30);

      final merged = <String, String>{};
      int? bestKey;

      for (final m in matches) {
        if (m.scientificName != scientificName) continue;
        bestKey ??= m.gbifKey;
        m.vernacularNames.forEach((lang, name) {
          if (_colLangs.contains(lang)) {
            merged.putIfAbsent(lang, () => name);
          }
        });
      }

      return (names: merged, gbifKey: bestKey);
    } catch (_) {}
    return (names: const <String, String>{}, gbifKey: null);
  }

  /// Az iNaturalist találatokhoz párhuzamosan lekéri a GBIF hétnyelvű neveit.
  Future<List<SpeciesSuggestion>> _enrichWithVernaculars(
    List<SpeciesSuggestion> suggestions,
  ) async {
    final results = await Future.wait(
      suggestions.map((s) async {
        if (s.scientificName == null) return s;
        final extra = await _fetchVernaculars(s.scientificName!);
        if (extra.names.isEmpty) return s;
        return SpeciesSuggestion(
          taxonId: s.taxonId,
          scientificName: s.scientificName,
          commonName: s.commonName,
          rank: s.rank,
          iconicTaxon: s.iconicTaxon,
          score: s.score,
          vernacularNames: extra.names,
          gbifKey: extra.gbifKey,
        );
      }),
    );
    return results;
  }

  /// A megjelenített név az app nyelvén.
  String _displayName(SpeciesSuggestion s) {
    final colLang = _appColLang();
    final localized = s.vernacularNames?[colLang];
    if (localized != null && localized.isNotEmpty) return localized;
    return s.commonName ?? s.scientificName ?? '?';
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _busy = true);
    try {
      final position = await _determinePosition();
      final file = await controller.takePicture();

      try {
        await controller.pausePreview();
      } catch (_) {}

      if (!mounted) return;

      // Megerősítés — mentés vagy elvetés
      final confirmed = await _confirmSave(File(file.path), l);
      if (confirmed != true) {
        if (!mounted) return;
        try {
          await controller.resumePreview();
        } catch (_) {}
        setState(() => _busy = false);
        return;
      }

      final rawSuggestions = await ref
          .read(identificationServiceProvider)
          .identify(File(file.path));

      // Az iNaturalist neveit kiegészítjük a GBIF hétnyelvű neveivel
      final enriched =
          await _enrichWithVernaculars(rawSuggestions.take(5).toList());

      final repo = ref.read(observationRepositoryProvider);

      // A megfigyelés 'pending' állapotban jön létre — csak szándékos
      // azonosítás után lesz 'published' (lásd setSpeciesFromName).
      final observation = await repo.create(
        latitude: position.latitude,
        longitude: position.longitude,
        photo: File(file.path),
      );

      if (!mounted) return;

      // Erős találat (>70%) vagy bizonytalan (40–70%) — mindkettőnél
      // felajánljuk a választást, mert az azonosítás szándékos aktus,
      // és ezzel a megfigyelés közzétehető. Találat nélkül 'pending' marad.
      final candidates =
          enriched.where((s) => s.score >= _minScoreToSuggest).toList();
      final strong =
          candidates.where((s) => s.score >= _autoIdentifyScore).toList();
      final weak =
          candidates.where((s) => s.score < _autoIdentifyScore).toList();

      SpeciesSuggestion? chosen = await _askSuggestion(
        [...strong, ...weak],
        l,
      );

      // Kézi keresés jelzés
      if (chosen != null && chosen.scientificName == '__MANUAL__') {
        if (!mounted) return;
        final match = await Navigator.of(context).push<ColMatch>(
          MaterialPageRoute(
            builder: (_) => const SpeciesSearchScreen(),
          ),
        );
        chosen = (match != null && match.scientificName != null)
            ? SpeciesSuggestion(
                scientificName: match.scientificName,
                commonName: match.commonName,
                rank: match.rank,
                iconicTaxon: match.kingdom,
                score: 100,
                vernacularNames: match.vernacularNames,
                gbifKey: match.gbifKey,
              )
            : null;
      }

      if (chosen != null && chosen.scientificName != null) {
        var vernaculars = chosen.vernacularNames ?? const <String, String>{};
        int? gbifKey = chosen.gbifKey;

        if (vernaculars.isEmpty) {
          final extra = await _fetchVernaculars(chosen.scientificName!);
          vernaculars = extra.names;
          gbifKey = extra.gbifKey;
        }

        await repo.setSpeciesFromName(
          observationId: observation.id,
          scientificName: chosen.scientificName!,
          commonName: chosen.commonName,
          iconicTaxon: chosen.iconicTaxon,
          vernacularNames: vernaculars,
          gbifKey: gbifKey,
        );
      }

      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l.cameraSaved)));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      messenger.showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _confirmSave(File file, AppLocalizations l) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(l.confirmTitle,
                  style: Theme.of(ctx).textTheme.titleMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  file,
                  height: 260,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 120,
                    child: Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l.confirmDiscard),
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(l.confirmSave),
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<SpeciesSuggestion?> _askSuggestion(
    List<SpeciesSuggestion> suggestions,
    AppLocalizations l,
  ) {
    return showModalBottomSheet<SpeciesSuggestion>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final maxHeight = MediaQuery.of(ctx).size.height * 0.85;

        return Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    l.identifyTitle,
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...suggestions.take(6).map((s) => ListTile(
                            leading: Icon(_iconForTaxon(s.iconicTaxon)),
                            title: Text(_displayName(s)),
                            subtitle: Text(s.scientificName ?? ''),
                            onTap: () => Navigator.of(ctx).pop(s),
                          )),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.travel_explore),
                        title: Text(l.identifyManual),
                        subtitle: Text(l.identifyManualHint),
                        onTap: () {
                          Navigator.of(ctx).pop(
                            const SpeciesSuggestion(
                              scientificName: '__MANUAL__',
                              score: 0,
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: Text(l.identifySkip),
                        onTap: () => Navigator.of(ctx).pop(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _iconForTaxon(String? iconic) {
    switch (iconic) {
      case 'Plantae':
        return Icons.local_florist;
      case 'Animalia':
        return Icons.pets;
      case 'Insecta':
        return Icons.bug_report;
      case 'Fungi':
        return Icons.eco;
      case 'Aves':
        return Icons.flutter_dash;
      default:
        return Icons.search;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.cameraTitle)),
      body: _buildBody(l),
    );
  }

  Widget _buildBody(AppLocalizations l) {
    if (_initializing) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorKey != null) {
      final message = _errorKey == 'noCamera'
          ? l.cameraNoCamera
          : l.cameraInitFailed('');
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_off, size: 64),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _initializing = true;
                    _errorKey = null;
                  });
                  _setUpCamera();
                },
                child: Text(l.cameraRetry),
              ),
            ],
          ),
        ),
      );
    }

    final controller = _controller!;

    final previewSize = controller.value.previewSize;
    double previewAspect = controller.value.aspectRatio;
    if (previewSize != null && previewSize.height != 0) {
      previewAspect = previewSize.width / previewSize.height;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait = constraints.maxHeight >= constraints.maxWidth;
        final displayAspect = isPortrait ? 1 / previewAspect : previewAspect;

        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: displayAspect,
                child: CameraPreview(controller),
              ),
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 90,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
            if (!_busy && _maxZoom > 1.0)
              Positioned(
                bottom: 130,
                left: 0,
                right: 0,
                child: _ZoomControl(
                  value: _zoom,
                  maxZoom: _maxZoom,
                  onChanged: _applyZoom,
                ),
              ),
            if (_busy)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black45,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            if (!_busy)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingActionButton.large(
                    onPressed: _capture,
                    child: const Icon(Icons.camera_alt, size: 36),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ZoomControl extends StatelessWidget {
  const _ZoomControl({
    required this.value,
    required this.maxZoom,
    required this.onChanged,
  });

  final double value;
  final double maxZoom;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final presets = <double>[1.0];
    if (maxZoom >= 2.0) presets.add(2.0);
    if (maxZoom >= 3.0) presets.add(3.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final p in presets)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _ZoomChip(
                  label: '${p.toStringAsFixed(0)}x',
                  selected: (value - p).abs() < 0.15,
                  onTap: () => onChanged(p),
                ),
              ),
          ],
        ),
        if (maxZoom > 1.0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 4),
            child: Slider(
              min: 1.0,
              max: maxZoom,
              value: value.clamp(1.0, maxZoom),
              onChanged: onChanged,
            ),
          ),
      ],
    );
  }
}

class _ZoomChip extends StatelessWidget {
  const _ZoomChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.black38,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
