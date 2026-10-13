import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/observations/observation.dart';
import '../features/search/observation_filter.dart';
import '../l10n/app_localizations.dart';

/// Megfigyelés-keresés — szöveges keresés, fajcsoport, azonosítottság,
/// dátumtartomány. Most a saját megfigyeléseken, később a prémium
/// közösségi nézet ugyanezt a képernyőt használja.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  ObservationFilter _filter = const ObservationFilter();
  List<Observation> _all = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items =
          await ref.read(observationRepositoryProvider).fetchMine();
      if (!mounted) return;
      setState(() {
        _all = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  String _langCode() {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  /// A megfigyelés összes ismert neve — nyelven független kereséshez.
  List<String> _namesOf(Observation o) {
    final names = <String>[];
    if (o.scientificName != null) names.add(o.scientificName!);
    if (o.commonNameHu != null) names.add(o.commonNameHu!);
    names.addAll(o.vernacularNames.values);
    return names;
  }

  List<Observation> get _results {
    if (_filter.isEmpty) return _all;
    return _all
        .where((o) => _filter.matches(o, searchNames: _namesOf(o)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = _langCode();
    final results = _results;

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
      ),
      body: Column(
        children: [
          // ── Kereső mező ─────────────────────────────────────────
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
                          setState(() => _filter = _filter.copyWith(text: ''));
                        },
                      )
                    : null,
              ),
            ),
          ),

          // ── Szűrő chipek ─────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: l.searchGroupPlants,
                  selected: _filter.group == 'plant',
                  onTap: () => setState(() {
                    _filter = _filter.group == 'plant'
                        ? _filter.copyWith(clearGroup: true)
                        : _filter.copyWith(group: 'plant');
                  }),
                ),
                _FilterChip(
                  label: l.searchGroupAnimals,
                  selected: _filter.group == 'animal',
                  onTap: () => setState(() {
                    _filter = _filter.group == 'animal'
                        ? _filter.copyWith(clearGroup: true)
                        : _filter.copyWith(group: 'animal');
                  }),
                ),
                _FilterChip(
                  label: l.searchGroupInsects,
                  selected: _filter.group == 'insect',
                  onTap: () => setState(() {
                    _filter = _filter.group == 'insect'
                        ? _filter.copyWith(clearGroup: true)
                        : _filter.copyWith(group: 'insect');
                  }),
                ),
                _FilterChip(
                  label: l.searchGroupFungi,
                  selected: _filter.group == 'fungus',
                  onTap: () => setState(() {
                    _filter = _filter.group == 'fungus'
                        ? _filter.copyWith(clearGroup: true)
                        : _filter.copyWith(group: 'fungus');
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l.searchIdentified,
                  selected: _filter.identifiedOnly == true,
                  onTap: () => setState(() {
                    _filter = _filter.identifiedOnly == true
                        ? _filter.copyWith(clearIdentified: true)
                        : _filter.copyWith(identifiedOnly: true);
                  }),
                ),
                _FilterChip(
                  label: l.searchUnidentified,
                  selected: _filter.identifiedOnly == false,
                  onTap: () => setState(() {
                    _filter = _filter.identifiedOnly == false
                        ? _filter.copyWith(clearIdentified: true)
                        : _filter.copyWith(identifiedOnly: false);
                  }),
                ),
              ],
            ),
          ),

          // ── Dátumtartomány ───────────────────────────────────────
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

          // ── Találatok ────────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(l.observationsError(_error!)))
                    : results.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.search_off, size: 48),
                                  const SizedBox(height: 12),
                                  Text(
                                    _all.isEmpty
                                        ? l.observationsEmpty
                                        : l.searchNoResults,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16, 8, 16, 4),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    l.searchResultCount(results.length),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: results.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, i) {
                                    final o = results[i];
                                    final name = o.hasSpecies
                                        ? o.displayNameFor(lang)
                                        : l.observationsUnknownSpecies;
                                    final when = o.observedAt != null
                                        ? o.observedAt!
                                            .toLocal()
                                            .toString()
                                            .substring(0, 16)
                                        : '';

                                    return ListTile(
                                      leading: o.photoPath != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                ref
                                                    .read(
                                                        observationRepositoryProvider)
                                                    .photoUrl(o.photoPath!),
                                                width: 56,
                                                height: 56,
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (_, __, ___) =>
                                                        const SizedBox(
                                                  width: 56,
                                                  height: 56,
                                                  child: Icon(
                                                      Icons.broken_image),
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
                                  },
                                ),
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

