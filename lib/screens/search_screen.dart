import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/observations/observation.dart';
import '../features/search/observation_filter.dart';
import '../l10n/app_localizations.dart';

/// Megfigyelés-keresés — két mód:
///  • Saját      — a bejelentkezett felhasználó megfigyelései (kliens-oldali szűrés)
///  • Közösségi  — mindenki megfigyelései (szerveroldali szűrés, prémium)
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  final _controller = TextEditingController();

  ObservationFilter _filter = const ObservationFilter();

  // Saját mód
  List<Observation> _mine = const [];
  bool _loadingMine = true;
  String? _errorMine;

  // Közösségi mód
  List<Observation> _community = const [];
  bool _loadingCommunity = false;
  String? _errorCommunity;
  bool? _isPremium;

  // Körzet-szűrő (közösségi fül)
  double? _zoneLat;
  double? _zoneLng;
  double? _zoneRadiusKm;
  bool _zoneBusy = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
    _loadMine();
    _checkPremium();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ── Betöltések ──────────────────────────────────────────────────────

  Future<void> _loadMine() async {
    setState(() {
      _loadingMine = true;
      _errorMine = null;
    });
    try {
      final items =
          await ref.read(observationRepositoryProvider).fetchMine();
      if (!mounted) return;
      setState(() {
        _mine = items;
        _loadingMine = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMine = '$e';
        _loadingMine = false;
      });
    }
  }

  Future<void> _checkPremium() async {
    final premium = await ref.read(searchRepositoryProvider).isPremium();
    if (!mounted) return;
    setState(() => _isPremium = premium);
  }

  Future<void> _loadCommunity() async {
    setState(() {
      _loadingCommunity = true;
      _errorCommunity = null;
    });
    try {
      final items = await ref.read(searchRepositoryProvider).loadCommunity(
            _filter,
            lat: _zoneLat,
            lng: _zoneLng,
            radiusKm: _zoneRadiusKm,
          );
      if (!mounted) return;
      setState(() {
        _community = items;
        _loadingCommunity = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorCommunity = '$e';
        _loadingCommunity = false;
      });
    }
  }

  // ── Körzet-szűrő ────────────────────────────────────────────────────

  /// A jelenlegi helyzet lekérése, és a körzet beállítása.
  Future<void> _setZoneHere() async {
    setState(() => _zoneBusy = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).zoneNoPermission),
          ),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      if (!mounted) return;
      setState(() {
        _zoneLat = pos.latitude;
        _zoneLng = pos.longitude;
        // Alapértelmezett sugár: 25 km
        _zoneRadiusKm ??= 25;
      });
      await _loadCommunity();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).zoneFailed),
        ),
      );
    } finally {
      if (mounted) setState(() => _zoneBusy = false);
    }
  }

  /// A körzet törlése.
  void _clearZone() {
    setState(() {
      _zoneLat = null;
      _zoneLng = null;
      _zoneRadiusKm = null;
    });
    _loadCommunity();
  }

  // ── Segédek ─────────────────────────────────────────────────────────

  String _langCode() {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  List<String> _namesOf(Observation o) {
    final names = <String>[];
    if (o.scientificName != null) names.add(o.scientificName!);
    if (o.commonNameHu != null) names.add(o.commonNameHu!);
    names.addAll(o.vernacularNames.values);
    return names;
  }

  List<Observation> get _mineResults {
    if (_filter.isEmpty) return _mine;
    return _mine
        .where((o) => _filter.matches(o, searchNames: _namesOf(o)))
        .toList();
  }

  /// Fejlesztői teszt: prémium bekapcsolása fizetés nélkül.
  /// Éles verzióban ezt a Stripe Checkout váltja fel — a UI marad.
  Future<void> _enableTestPremium() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx).premiumTestTitle),
        content: Text(AppLocalizations.of(ctx).premiumTestBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(ctx).confirmDiscard),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(ctx).premiumSubscribe),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final err = await ref.read(searchRepositoryProvider).activateTestPremium();
    if (!mounted) return;

    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
      return;
    }

    await _checkPremium();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).premiumActivated)),
    );
    await _loadCommunity();
  }

  /// Fejlesztői teszt: visszaállítás ingyenes csomagra.
  Future<void> _disableTestPremium() async {
    final err = await ref.read(searchRepositoryProvider).deactivatePremium();
    if (!mounted) return;

    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    await _checkPremium();
    if (!mounted) return;
    setState(() => _community = const []);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).premiumDeactivated)),
    );
  }

  // ── UI ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.searchTitle),
        actions: [
          if (_filter.hasActiveFilter)
            IconButton(
              tooltip: l.searchClear,
              icon: const Icon(Icons.filter_alt_off),
              onPressed: () {
                _controller.clear();
                setState(() => _filter = const ObservationFilter());
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l.searchTabMine),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    (_isPremium == true)
                        ? Icons.public
                        : Icons.lock_outline,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(l.searchTabCommunity),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Kereső mező
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: (v) => setState(() {
                _filter = _filter.copyWith(text: v);
              }),
              decoration: InputDecoration(
                hintText: l.searchFieldHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(
                              () => _filter = _filter.copyWith(text: ''));
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Szűrő chipek
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _chip(l.searchGroupPlants, 'plant'),
                _chip(l.searchGroupAnimals, 'animal'),
                _chip(l.searchGroupInsects, 'insect'),
                _chip(l.searchGroupFungi, 'fungus'),
                const SizedBox(width: 8),
                _chipState(l.searchIdentified, true),
                _chipState(l.searchUnidentified, false),
              ],
            ),
          ),

          // Dátumtartomány
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.date_range, size: 18),
                    label: Text(
                      _filter.from == null
                          ? l.searchFromDate
                          : _fmt(_filter.from!),
                    ),
                    onPressed: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _filter.from ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (d != null) {
                        setState(() => _filter = _filter.copyWith(from: d));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.date_range, size: 18),
                    label: Text(
                      _filter.to == null
                          ? l.searchToDate
                          : _fmt(_filter.to!),
                    ),
                    onPressed: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _filter.to ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (d != null) {
                        setState(() => _filter = _filter.copyWith(to: d));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),

          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _mineTab(l),
                _communityTab(l),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: _filter.group == value,
        onSelected: (_) => setState(() {
          _filter = _filter.group == value
              ? _filter.copyWith(clearGroup: true)
              : _filter.copyWith(group: value);
        }),
      ),
    );
  }

  Widget _chipState(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: _filter.identifiedOnly == value,
        onSelected: (_) => setState(() {
          _filter = _filter.identifiedOnly == value
              ? _filter.copyWith(clearIdentified: true)
              : _filter.copyWith(identifiedOnly: value);
        }),
      ),
    );
  }

  // ── Saját fül ───────────────────────────────────────────────────────

  Widget _mineTab(AppLocalizations l) {
    final lang = _langCode();
    final results = _mineResults;

    if (_loadingMine) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMine != null) {
      return Center(child: Text(l.observationsError(_errorMine!)));
    }
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off, size: 48),
              const SizedBox(height: 12),
              Text(
                _mine.isEmpty ? l.observationsEmpty : l.searchNoResults,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _countRow(l.searchResultCount(results.length)),
        Expanded(
          child: ListView.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) =>
                _row(results[i], lang, l, showThumb: true),
          ),
        ),
      ],
    );
  }

  // ── Közösségi fül ───────────────────────────────────────────────────

  Widget _communityTab(AppLocalizations l) {
    if (_isPremium == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_isPremium == false) {
      return _premiumPaywall(l);
    }

    final lang = _langCode();

    return Column(
      children: [
        // Prémium jelzés + visszaállítás (fejlesztői teszt)
        Container(
          color: const Color(0xFFE8EEF7),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.workspace_premium,
                  size: 16, color: Color(0xFF1F3864)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l.premiumActive,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              TextButton(
                onPressed: _disableTestPremium,
                child: Text(l.premiumDeactivate),
              ),
            ],
          ),
        ),

        // Körzet-sáv
        Container(
          color: Colors.black.withValues(alpha: 0.04),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.my_location, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _zoneRadiusKm == null
                      ? l.zoneNone
                      : l.zoneActive(_zoneRadiusKm!.round()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              if (_zoneRadiusKm != null) ...[
                DropdownButton<double>(
                  value: const [5.0, 10.0, 25.0, 50.0, 100.0]
                          .contains(_zoneRadiusKm)
                      ? _zoneRadiusKm
                      : 25.0,
                  underline: const SizedBox.shrink(),
                  items: const [5.0, 10.0, 25.0, 50.0, 100.0]
                      .map((r) => DropdownMenuItem(
                            value: r,
                            child: Text('${r.round()} km'),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _zoneRadiusKm = v);
                    _loadCommunity();
                  },
                ),
                IconButton(
                  tooltip: l.zoneClear,
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: _clearZone,
                ),
              ] else
                TextButton.icon(
                  icon: _zoneBusy
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_location_alt, size: 18),
                  label: Text(l.zoneHere),
                  onPressed: _zoneBusy ? null : _setZoneHere,
                ),
            ],
          ),
        ),

        Expanded(
          child: _loadingCommunity
              ? const Center(child: CircularProgressIndicator())
              : _errorCommunity != null
                  ? Center(child: Text(l.observationsError(_errorCommunity!)))
                  : _community.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.public_off, size: 48),
                                const SizedBox(height: 12),
                                Text(
                                  l.searchCommunityEmpty,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                FilledButton.icon(
                                  icon: const Icon(Icons.refresh),
                                  label: Text(l.searchCommunityLoad),
                                  onPressed: _loadCommunity,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            _countRow(
                                l.searchResultCount(_community.length)),
                            Expanded(
                              child: ListView.separated(
                                itemCount: _community.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, i) => _row(
                                  _community[i],
                                  lang,
                                  l,
                                  showThumb: false,
                                ),
                              ),
                            ),
                          ],
                        ),
        ),
      ],
    );
  }

  /// A prémium díjtábla — fizetés előtti állapot.
  Widget _premiumPaywall(AppLocalizations l) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.workspace_premium,
                      size: 56, color: Color(0xFF1F3864)),
                  const SizedBox(height: 12),
                  Text(
                    l.premiumTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.premiumSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  _featureRow(l.premiumFeature1),
                  _featureRow(l.premiumFeature2),
                  _featureRow(l.premiumFeature3),
                  const SizedBox(height: 20),
                  Text(
                    l.premiumPrice,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.star),
                    label: Text(l.premiumSubscribe),
                    onPressed: _enableTestPremium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.premiumTestNote,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _featureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  // ── Közös lista-elem ────────────────────────────────────────────────

  Widget _countRow(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }

  Widget _row(
    Observation o,
    String lang,
    AppLocalizations l, {
    required bool showThumb,
  }) {
    final name =
        o.hasSpecies ? o.displayNameFor(lang) : l.observationsUnknownSpecies;
    final when = o.observedAt != null
        ? o.observedAt!.toLocal().toString().substring(0, 16)
        : '';

    return ListTile(
      leading: (showThumb && o.photoPath != null)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                ref.read(observationRepositoryProvider).photoUrl(o.photoPath!),
                width: 56,
                height: 56,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.broken_image),
                ),
              ),
            )
          : const Icon(Icons.park),
      title: Text(name),
      subtitle: Text(
        '${o.latitude.toStringAsFixed(4)}, '
        '${o.longitude.toStringAsFixed(4)}'
        '${when.isNotEmpty ? ' · $when' : ''}',
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
