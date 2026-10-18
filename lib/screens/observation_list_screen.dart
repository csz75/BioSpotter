import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/identification/col_match.dart';
import '../features/identification/species_suggestion.dart';
import '../features/observations/observation.dart';
import '../l10n/app_localizations.dart';
import 'species_search_screen.dart';

class ObservationListScreen extends ConsumerStatefulWidget {
  const ObservationListScreen({super.key});

  @override
  ConsumerState<ObservationListScreen> createState() =>
      _ObservationListScreenState();
}

class _ObservationListScreenState
    extends ConsumerState<ObservationListScreen> {
  late Future<List<Observation>> _future;

  static const _colLangs = ['hun', 'eng', 'deu', 'fra', 'spa', 'ita', 'pol'];

  @override
  void initState() {
    super.initState();
    _future = ref.read(observationRepositoryProvider).fetchMine();
  }

  /// Azonnali újratöltés — minden hívás új Future példányt ad a
  /// FutureBuilder-nek, ezért az újra lefut.
  Future<void> _reload() async {
    final fresh = ref.read(observationRepositoryProvider).fetchMine();
    setState(() {
      _future = fresh;
    });
    try {
      await fresh;
    } catch (_) {}
  }

  /// Az aktuális app-nyelv kódja (pl. "hu"), a rendszer nyelvére visszaesve.
  String _langCode(BuildContext context) {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  /// Az app nyelvének ISO 639-3 kódja (a népies nevek kulcsa).
  String _appColLang() {
    final code = _langCode(context);
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
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = _langCode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.observationsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _reload(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<Observation>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(l.observationsError('${snapshot.error}')),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(child: Text(l.observationsEmpty)),
                  ),
                ],
              );
            }
            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final o = items[i];
                final when = o.observedAt != null
                    ? o.observedAt!.toLocal().toString().substring(0, 16)
                    : '';
                final name = o.hasSpecies
                    ? o.displayNameFor(lang)
                    : l.observationsUnknownSpecies;

                // A listában a miniatűrt használjuk, ha van; egyébként a nagy fotót.
                final listPath = o.listPhotoPath;

                return ListTile(
                  leading: listPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            ref
                                .read(observationRepositoryProvider)
                                .photoUrl(listPath),
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
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
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showDetail(context, o, l, lang),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDetail(
    BuildContext context,
    Observation o,
    AppLocalizations l,
    String lang,
  ) {
    final photoUrl = o.photoPath != null
        ? ref.read(observationRepositoryProvider).photoUrl(o.photoPath!)
        : null;
    final name = o.hasSpecies
        ? o.displayNameFor(lang)
        : l.observationsUnknownSpecies;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.4,
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
              if (photoUrl != null)
                GestureDetector(
                  onTap: () => _showFullImage(context, photoUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        Image.network(
                          photoUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return const SizedBox(
                              height: 200,
                              child:
                                  Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (_, __, ___) => const SizedBox(
                            height: 200,
                            child: Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.black54,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            l.tapForFullSize,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(name, style: Theme.of(ctx).textTheme.titleLarge),
              if (o.scientificName != null && o.scientificName != name) ...[
                const SizedBox(height: 4),
                Text(
                  o.scientificName!,
                  style: Theme.of(ctx)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
              const SizedBox(height: 8),
              Text(l.observationsGps(
                o.latitude.toStringAsFixed(5),
                o.longitude.toStringAsFixed(5),
              )),
              if (o.observedAt != null)
                Text(l.observationsDateTime(o.observedAt!.toLocal().toString())),

              // ── Moderációs állapot ─────────────────────────────────
              if (!o.isPublished) ...[
                const Divider(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      o.isPending
                          ? Icons.hourglass_empty
                          : (o.isFlagged ? Icons.flag : Icons.block),
                      size: 18,
                      color: o.isPending
                          ? Colors.orange.shade700
                          : (o.isFlagged
                              ? Colors.red.shade700
                              : Colors.grey.shade700),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        o.isPending
                            ? l.statusPending
                            : (o.isFlagged
                                ? l.statusFlagged
                                : l.statusRejected),
                        style: Theme.of(ctx).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],

              const Divider(height: 32),

              // ── Műveletek ──────────────────────────────────────────

              // 1. Faj megadása / módosítása — kézi keresés
              FilledButton.icon(
                icon: const Icon(Icons.travel_explore),
                label: Text(l.obsSetSpecies),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await Future.delayed(const Duration(milliseconds: 250));
                  if (!mounted) return;
                  await _changeSpecies(o, l);
                },
              ),
              const SizedBox(height: 8),

              // 2. Újra-azonosítás az iNaturalist-tel
              if (o.photoPath != null)
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: Text(l.obsReidentify),
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await Future.delayed(const Duration(milliseconds: 250));
                    if (!mounted) return;
                    await _reidentify(o, l);
                  },
                ),
              const SizedBox(height: 8),

              // 3. Törlés
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                icon: const Icon(Icons.delete_outline),
                label: Text(l.obsDelete),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await Future.delayed(const Duration(milliseconds: 250));
                  if (!mounted) return;
                  await _deleteObservation(o, l);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// A hétnyelvű nevek a SAJÁT adatbázisból (nincs GBIF-hívás).
  ///
  /// A `species` tábla ~1,13 millió fajt tartalmaz, benne a hét nyelv
  /// népies neveivel — ezért egyetlen Supabase-lekérdezés elég.
  Future<({Map<String, String> names, int? gbifKey})>
      _fetchVernacularsFromGbif(String scientificName) async {
    try {
      final res = await ref
          .read(supabaseClientProvider)
          .from('species')
          .select('vernacular_names, col_id')
          .eq('scientific_name', scientificName)
          .maybeSingle();

      if (res == null) {
        return (names: const <String, String>{}, gbifKey: null);
      }

      final merged = <String, String>{};
      final raw = res['vernacular_names'];
      if (raw is Map) {
        raw.forEach((k, v) {
          final key = k.toString();
          if (v is String && v.isNotEmpty && _colLangs.contains(key)) {
            merged[key] = v;
          }
        });
      }

      final colId = res['col_id'] as String?;
      return (
        names: merged,
        gbifKey: colId != null ? int.tryParse(colId) : null,
      );
    } catch (_) {}
    return (names: const <String, String>{}, gbifKey: null);
  }

  /// Az iNaturalist találatokhoz a saját adatbázisból kérjük a hétnyelvű
  /// neveket, hogy a lista az APP nyelvén jelenjen meg.
  Future<List<SpeciesSuggestion>> _enrichWithVernaculars(
    List<SpeciesSuggestion> suggestions,
  ) async {
    final results = await Future.wait(
      suggestions.map((s) async {
        if (s.scientificName == null) return s;
        final extra = await _fetchVernacularsFromGbif(s.scientificName!);
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

  /// 1. Faj megadása / módosítása a fajkeresővel (saját adatbázis).
  Future<void> _changeSpecies(Observation o, AppLocalizations l) async {
    final match = await Navigator.of(context).push<ColMatch>(
      MaterialPageRoute(builder: (_) => const SpeciesSearchScreen()),
    );
    if (match == null || match.scientificName == null) return;
    if (!mounted) return;

    try {
      await ref.read(observationRepositoryProvider).updateSpecies(
            observationId: o.id,
            scientificName: match.scientificName!,
            commonName: match.commonName,
            iconicTaxon: match.kingdom,
            vernacularNames: match.vernacularNames,
            gbifKey: match.gbifKey,
          );

      if (mounted) await _reload();

      if (!mounted) return;
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.obsSpeciesSaved)),
        );
      } catch (_) {}
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.observationsError('$e'))),
      );
    }
  }

  /// 2. Újra-azonosítás — a meglévő fotót újraküldjük az iNaturalist-nek.
  Future<void> _reidentify(Observation o, AppLocalizations l) async {
    if (o.photoPath == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repo = ref.read(observationRepositoryProvider);
      final file = await repo.downloadPhoto(o.photoPath!);

      final rawSuggestions =
          await ref.read(identificationServiceProvider).identify(file);

      // Az iNaturalist neveit kiegészítjük a SAJÁT adatbázis hétnyelvű neveivel,
      // hogy a találati lista az APP nyelvén jelenjen meg.
      final suggestions = await _enrichWithVernaculars(
        rawSuggestions.take(5).toList(),
      );

      if (mounted) Navigator.of(context).pop();

      if (suggestions.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.identifyNone)),
        );
        return;
      }

      if (!mounted) return;

      final chosen = await showModalBottomSheet<SpeciesSuggestion>(
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(l.identifyTitle,
                        style: Theme.of(ctx).textTheme.titleMedium),
                  ),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ...suggestions.map((s) => ListTile(
                              leading: Icon(_iconForTaxon(s.iconicTaxon)),
                              title: Text(_displayName(s)),
                              subtitle: Text(s.scientificName ?? ''),
                              onTap: () => Navigator.of(ctx).pop(s),
                            )),
                        ListTile(
                          leading: const Icon(Icons.close),
                          title: Text(l.identifySkip),
                          onTap: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (chosen == null || chosen.scientificName == null) return;
      if (!mounted) return;

      // A hétnyelvű nevek — ha a találatnál nincs, pótoljuk a saját DB-ből
      var vernaculars = chosen.vernacularNames ?? const <String, String>{};
      int? gbifKey = chosen.gbifKey;
      if (vernaculars.isEmpty) {
        final extra = await _fetchVernacularsFromGbif(chosen.scientificName!);
        vernaculars = extra.names;
        gbifKey = extra.gbifKey;
      }

      await repo.updateSpecies(
        observationId: o.id,
        scientificName: chosen.scientificName!,
        commonName: chosen.commonName,
        iconicTaxon: chosen.iconicTaxon,
        vernacularNames: vernaculars,
        gbifKey: gbifKey,
      );

      if (mounted) await _reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.obsSpeciesSaved)),
      );
    } catch (e) {
      if (mounted) {
        try {
          Navigator.of(context).pop();
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.observationsError('$e'))),
        );
      }
    }
  }

  /// 3. Megfigyelés törlése megerősítés után.
  Future<void> _deleteObservation(Observation o, AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.obsDeleteConfirmTitle),
        content: Text(l.obsDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.confirmDiscard),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.obsDelete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    try {
      await ref.read(observationRepositoryProvider).deleteObservation(o.id);
      if (mounted) await _reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.obsDeleted)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.observationsError('$e'))),
      );
    }
  }

  void _showFullImage(BuildContext context, String photoUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullImageScreen(photoUrl: photoUrl),
      ),
    );
  }
}

/// Teljes képernyős képnézet — csippentéssel nagyítható.
class _FullImageScreen extends StatelessWidget {
  const _FullImageScreen({required this.photoUrl});

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 5.0,
          child: Image.network(
            photoUrl,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.broken_image, color: Colors.white, size: 64),
            ),
          ),
        ),
      ),
    );
  }
}
