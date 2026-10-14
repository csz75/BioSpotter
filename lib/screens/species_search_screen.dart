import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/identification/col_match.dart';
import '../l10n/app_localizations.dart';

/// A GBIF-alapú fajnév-kereső.
/// Élő keresés (400 ms késleltetéssel), nyelv-választóval,
/// részletnézettel, és a kiválasztott faj visszaadásával
/// (`Navigator.pop(match)`).
class SpeciesSearchScreen extends ConsumerStatefulWidget {
  const SpeciesSearchScreen({super.key});

  @override
  ConsumerState<SpeciesSearchScreen> createState() =>
      _SpeciesSearchScreenState();
}

class _SpeciesSearchScreenState extends ConsumerState<SpeciesSearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  Timer? _debounce;
  List<ColMatch> _results = const [];
  bool _loading = false;
  bool _searched = false;

  /// A keresés nyelve — alapból az app nyelve, de átváltható.
  late String _lang;

  @override
  void initState() {
    super.initState();
    _lang = _currentAppLang();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  String _currentAppLang() {
    final code = localeController.locale?.languageCode;
    if (code != null) return _toColLang(code);
    final sys = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return _toColLang(sys);
  }

  /// Az app ISO 639-1 kódját ISO 639-3-ra váltja (a GBIF ezt használja).
  String _toColLang(String code) {
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

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() {
        _results = const [];
        _searched = false;
        _loading = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _runSearch(value);
    });
  }

  Future<void> _runSearch(String query) async {
    final q = query.trim();
    if (q.length < 2) return;

    setState(() => _loading = true);
    final matches = await ref
        .read(colSearchServiceProvider)
        .search(query: q, language: _lang);

    if (!mounted) return;
    setState(() {
      _results = matches;
      _loading = false;
      _searched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.searchTitle)),
      body: Column(
        children: [
          // Kereső mező
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              onSubmitted: _runSearch,
              decoration: InputDecoration(
                hintText: l.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _onChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Nyelv-választó sor
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.translate, size: 18),
                const SizedBox(width: 8),
                Text(l.searchLanguage,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: AppLanguage.all.map((lang) {
                        final code = _toColLang(lang.code);
                        final selected = code == _lang;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label:
                                Text('${lang.flag} ${lang.code.toUpperCase()}'),
                            selected: selected,
                            onSelected: (_) {
                              setState(() => _lang = code);
                              if (_controller.text.trim().length >= 2) {
                                _runSearch(_controller.text);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 16),
          // Találatok
          Expanded(child: _buildResults(l)),
        ],
      ),
    );
  }

  Widget _buildResults(AppLocalizations l) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_searched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l.searchStartHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off, size: 48),
              const SizedBox(height: 12),
              Text(l.searchNoResults, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                l.searchTryOtherLanguage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) => _resultRow(context, _results[i], l),
    );
  }

  /// Egy találat sora — sima GestureDetectorral, a legbiztosabb módon.
  Widget _resultRow(BuildContext context, ColMatch m, AppLocalizations l) {
    final localized = m.vernacularNames[_lang];
    final title = localized ?? m.scientificName ?? '?';
    final isDifferent = localized != null && localized != m.scientificName;

    return InkWell(
      onTap: () {
        debugPrint('>>> ONTAP FUTOTT: ${m.scientificName}');
        FocusScope.of(context).unfocus();
        _showDetail(context, m, l);
        debugPrint('>>> _showDetail VISSZATÉRT');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_iconForKingdom(m.kingdom)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (isDifferent) ...[
                    const SizedBox(height: 2),
                    Text(
                      m.scientificName ?? '',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                  if (m.family != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      m.family!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  /// A faj részletnézete — ugyanúgy alsó lap, mint a megfigyeléslistán.
  /// Innen lehet kiválasztani a fajt.
  void _showDetail(
    BuildContext context,
    ColMatch m,
    AppLocalizations l,
  ) {
    debugPrint('>>> _SHOWDETAIL ELINDULT');

    final localized = m.vernacularNames[_lang];
    final title = localized ?? m.scientificName ?? '?';
    final isDifferent = localized != null && localized != m.scientificName;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.35,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
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

              // Cím — a kiválasztott nyelvű név, ha van
              Text(title, style: Theme.of(ctx).textTheme.titleLarge),
              if (isDifferent) ...[
                const SizedBox(height: 4),
                Text(
                  m.scientificName ?? '',
                  style: Theme.of(ctx)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
              const SizedBox(height: 16),

              // Rendszertani adatok
              _detailRow(ctx, l.searchKingdom, _kingdomLabel(m.kingdom, l)),
              if (m.family != null)
                _detailRow(ctx, l.searchFamily, m.family!),
              if (m.gbifKey != null)
                _detailRow(ctx, l.searchGbifKey, '${m.gbifKey}'),

              const Divider(height: 32),

              // Hétnyelvű nevek — mindegyik nyelven
              if (m.vernacularNames.isNotEmpty) ...[
                Text(
                  l.searchVernaculars,
                  style: Theme.of(ctx).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ...m.vernacularNames.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 44,
                          child: Text(
                            e.key.toUpperCase(),
                            style: Theme.of(ctx)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(child: Text(e.value)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              const Divider(height: 32),

              // Kiválasztás
              FilledButton.icon(
                icon: const Icon(Icons.check),
                label: Text(l.searchChoose),
                onPressed: () {
                  Navigator.of(ctx).pop(); // alsó lap bezárása
                  Navigator.of(context).pop(m); // a faj visszaadása
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext ctx, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// A királyság neve a felület nyelvén.
  String _kingdomLabel(String? kingdom, AppLocalizations l) {
    switch (kingdom) {
      case 'Animalia':
        return l.searchKingdomAnimalia;
      case 'Plantae':
        return l.searchKingdomPlantae;
      case 'Fungi':
        return l.searchKingdomFungi;
      default:
        return kingdom ?? '—';
    }
  }

  IconData _iconForKingdom(String? kingdom) {
    switch (kingdom) {
      case 'Animalia':
        return Icons.pets;
      case 'Plantae':
        return Icons.local_florist;
      case 'Fungi':
        return Icons.eco;
      default:
        return Icons.category;
    }
  }
}
