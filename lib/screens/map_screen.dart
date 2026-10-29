import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/observations/observation.dart';
import '../features/search/observation_filter.dart';
import '../l10n/app_localizations.dart';
import '../widgets/observation_detail_sheet.dart';

/// Megfigyelések térképen.
///  • Saját (zöld) — mindig látszik
///  • Közösségi (kék) — prémium, kapcsolóval
///  • Fajkereső — mindkét réteget szűri (a közösségit a szerveren)
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late Future<List<Observation>> _mineFuture;

  List<Observation> _community = const [];
  bool _loadingCommunity = false;

  /// Megjelenjenek-e a közösségi (mások) megfigyelései is.
  bool _showCommunity = false;

  /// Fajnév-kereső szövege — a „Saját" réteget kliens-oldalon,
  /// a „Közösségi" réteget a szerveren szűri.
  final _searchController = TextEditingController();
  String _searchText = '';
  Timer? _debounce;

  static const _fallbackCenter = LatLng(47.1625, 19.5033);

  @override
  void initState() {
    super.initState();
    _mineFuture = ref.read(observationRepositoryProvider).fetchMine();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // ── Betöltések ──────────────────────────────────────────────────────

  /// A közösségi pontok betöltése — a keresőszöveggel szűrve.
  Future<void> _loadCommunity() async {
    setState(() => _loadingCommunity = true);
    try {
      final filter = ObservationFilter(text: _searchText);
      final items = await ref
          .read(searchRepositoryProvider)
          .loadCommunity(filter, limit: 300);
      if (!mounted) return;
      setState(() {
        _community = items;
        _loadingCommunity = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCommunity = false);
    }
  }

  Future<void> _toggleCommunity(bool on) async {
    setState(() => _showCommunity = on);
    if (on && _community.isEmpty) await _loadCommunity();
  }

  Future<void> _reloadMine() async {
    final fresh = ref.read(observationRepositoryProvider).fetchMine();
    setState(() => _mineFuture = fresh);
    try {
      await fresh;
    } catch (_) {}
  }

  /// Keresőszöveg változása — 400 ms késleltetés, majd újratöltés.
  void _onSearchChanged(String v) {
    setState(() => _searchText = v);

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      // A közösségi réteg szerveroldali újratöltése, ha látszik.
      if (_showCommunity) _loadCommunity();
    });
  }

  String _langCode(BuildContext context) {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  /// Csak az érvényes koordinátájú megfigyelések.
  List<Observation> _valid(List<Observation> items) => items
      .where((o) => o.latitude.abs() > 0.0001 || o.longitude.abs() > 0.0001)
      .toList();

  /// Kliens-oldali névszűrés (a saját réteghez).
  /// A faj minden ismert nevére keres, nyelvfüggetlenül.
  List<Observation> _nameFilter(List<Observation> items) {
    final q = _searchText.trim().toLowerCase();
    if (q.isEmpty) return items;

    return items.where((o) {
      final names = <String>[
        if (o.scientificName != null) o.scientificName!,
        if (o.commonNameHu != null) o.commonNameHu!,
        ...o.vernacularNames.values,
      ];
      return names.any((n) => n.toLowerCase().contains(q));
    }).toList();
  }

  // ── UI ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = _langCode(context);

    // A prémium állapot közös providerből — friss aktiválás után is helyes.
    final isPremium = ref.watch(premiumProvider).valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.mapTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _reloadMine();
              if (_showCommunity) _loadCommunity();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Fajkereső ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l.mapSearchHint,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // ── Térkép ──────────────────────────────────────────────────
          Expanded(
            child: FutureBuilder<List<Observation>>(
              future: _mineFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(l.observationsError('${snapshot.error}')),
                  );
                }

                // A saját réteg kliens-oldali szűrése a keresőszöveggel.
                final mineFiltered =
                    _nameFilter(_valid(snapshot.data ?? const []));

                // A közösségi réteget már a szerver szűrte.
                final communityFiltered = (_showCommunity && isPremium)
                    ? _valid(_community)
                    : <Observation>[];

                final all = [...mineFiltered, ...communityFiltered];
                final center = all.isNotEmpty
                    ? LatLng(all.first.latitude, all.first.longitude)
                    : _fallbackCenter;

                final hasQuery = _searchText.trim().isNotEmpty;
                final nothingFound = all.isEmpty && hasQuery;

                return Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: center,
                        initialZoom: all.isNotEmpty ? 12 : 7,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'hu.therma.biospotter',
                        ),

                        // Közösségi pontok (kék) — alul.
                        MarkerLayer(
                          markers: communityFiltered
                              .map((o) => Marker(
                                    point: LatLng(o.latitude, o.longitude),
                                    width: 36,
                                    height: 36,
                                    child: GestureDetector(
                                      onTap: () => showObservationDetail(
                                        context,
                                        ref,
                                        o,
                                        lang,
                                        allowReport: true,
                                        allowLike: true,
                                      ),
                                      child: Icon(
                                        Icons.location_on,
                                        size: 30,
                                        color: Colors.blue.shade600,
                                        shadows: const [
                                          Shadow(
                                              color: Colors.black45,
                                              blurRadius: 3),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),

                        // Saját pontok (zöld) — felül, nagyobb.
                        MarkerLayer(
                          markers: mineFiltered
                              .map((o) => Marker(
                                    point: LatLng(o.latitude, o.longitude),
                                    width: 44,
                                    height: 44,
                                    child: GestureDetector(
                                      onTap: () => showObservationDetail(
                                        context,
                                        ref,
                                        o,
                                        lang,
                                        showStatusLine: true,
                                        showLikeCount: true,
                                      ),
                                      child: Icon(
                                        Icons.location_on,
                                        size: 38,
                                        color: Colors.green.shade700,
                                        shadows: const [
                                          Shadow(
                                              color: Colors.black45,
                                              blurRadius: 4),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),

                    // Számláló
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l.mapObservationCount(mineFiltered.length)),
                              if (communityFiltered.isNotEmpty)
                                Text(
                                  l.mapCommunityCount(
                                      communityFiltered.length),
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Prémium: közösségi kapcsoló
                    Positioned(
                      top: 12,
                      right: 12,
                      child: isPremium
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_loadingCommunity)
                                      const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    else
                                      const Icon(Icons.public,
                                          size: 18, color: Colors.blue),
                                    const SizedBox(width: 6),
                                    Text(l.mapCommunityToggle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                    Switch(
                                      value: _showCommunity,
                                      onChanged: _loadingCommunity
                                          ? null
                                          : _toggleCommunity,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.lock_outline, size: 16),
                                    const SizedBox(width: 6),
                                    Text(l.mapCommunityLocked,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ],
                                ),
                              ),
                            ),
                    ),

                    // „Nincs találat" — csak keresés közben
                    if (nothingFound)
                      Positioned(
                        top: 70,
                        left: 12,
                        right: 12,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(l.mapNoMatch),
                          ),
                        ),
                      ),

                    // Üres térkép — nincs egyáltalán megfigyelés
                    if (all.isEmpty && !hasQuery)
                      Positioned(
                        top: 70,
                        left: 12,
                        right: 12,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(l.mapEmpty),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
