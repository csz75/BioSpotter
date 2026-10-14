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
/// Koppintás bármelyik jelölőre → közös részletnézet.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late Future<List<Observation>> _mineFuture;

  List<Observation> _community = const [];
  bool _loadingCommunity = false;
  bool? _isPremium;

  /// Megjelenjenek-e a közösségi (mások) megfigyelései is.
  bool _showCommunity = false;

  static const _fallbackCenter = LatLng(47.1625, 19.5033);

  @override
  void initState() {
    super.initState();
    _mineFuture = ref.read(observationRepositoryProvider).fetchMine();
    _checkPremium();
  }

  // ── Betöltések ──────────────────────────────────────────────────────

  Future<void> _checkPremium() async {
    final premium = await ref.read(searchRepositoryProvider).isPremium();
    if (!mounted) return;
    setState(() => _isPremium = premium);
  }

  Future<void> _loadCommunity() async {
    setState(() => _loadingCommunity = true);
    try {
      final items = await ref
          .read(searchRepositoryProvider)
          .loadCommunity(const ObservationFilter(), limit: 300);
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

  String _langCode(BuildContext context) {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  /// Csak az érvényes koordinátájú megfigyelések.
  List<Observation> _valid(List<Observation> items) =>
      items.where((o) => o.latitude.abs() > 0.0001 || o.longitude.abs() > 0.0001).toList();

  // ── UI ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = _langCode(context);

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
      body: FutureBuilder<List<Observation>>(
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

          final minePoints = _valid(snapshot.data ?? const []);
          final communityPoints = (_showCommunity && _isPremium == true)
              ? _valid(_community)
              : <Observation>[];

          final all = [...minePoints, ...communityPoints];
          final center = all.isNotEmpty
              ? LatLng(all.first.latitude, all.first.longitude)
              : _fallbackCenter;

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
                    markers: communityPoints
                        .map((o) => Marker(
                              point: LatLng(o.latitude, o.longitude),
                              width: 36,
                              height: 36,
                              child: GestureDetector(
                                onTap: () => showObservationDetail(
                                    context, ref, o, lang),
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
                    markers: minePoints
                        .map((o) => Marker(
                              point: LatLng(o.latitude, o.longitude),
                              width: 44,
                              height: 44,
                              child: GestureDetector(
                                onTap: () => showObservationDetail(
                                    context, ref, o, lang),
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
                        Text(l.mapObservationCount(minePoints.length)),
                        if (communityPoints.isNotEmpty)
                          Text(
                            l.mapCommunityCount(communityPoints.length),
                            style: Theme.of(context).textTheme.bodySmall,
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
                child: _isPremium == true
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

              if (minePoints.isEmpty && communityPoints.isEmpty)
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
    );
  }
}
