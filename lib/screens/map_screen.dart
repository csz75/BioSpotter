import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/observations/observation.dart';
import '../l10n/app_localizations.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late final Future<List<Observation>> _future;
  Observation? _selected;

  static const _fallbackCenter = LatLng(47.1625, 19.5033);

  @override
  void initState() {
    super.initState();
    _future = ref.read(observationRepositoryProvider).fetchMine();
  }

  String _langCode(BuildContext context) {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = _langCode(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.mapTitle)),
      body: FutureBuilder<List<Observation>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l.observationsError('${snapshot.error}')));
          }

          final items = snapshot.data ?? [];
          final points = items
              .where((o) =>
                  o.latitude.abs() > 0.0001 || o.longitude.abs() > 0.0001)
              .toList();

          final center = points.isNotEmpty
              ? LatLng(points.first.latitude, points.first.longitude)
              : _fallbackCenter;

          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: points.isNotEmpty ? 12 : 7,
                  onTap: (_, __) => setState(() => _selected = null),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'hu.therma.biospotter',
                  ),
                  MarkerLayer(
                    markers: points.map((o) {
                      final isSelected = _selected?.id == o.id;
                      return Marker(
                        point: LatLng(o.latitude, o.longitude),
                        width: 44,
                        height: 44,
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = o),
                          child: Icon(
                            Icons.location_on,
                            size: isSelected ? 44 : 36,
                            color: isSelected
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                            shadows: const [
                              Shadow(color: Colors.black45, blurRadius: 4),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: Text(l.mapObservationCount(points.length)),
                  ),
                ),
              ),
              if (_selected != null)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 16,
                  child: _ObservationCard(
                    observation: _selected!,
                    lang: lang,
                    onClose: () => setState(() => _selected = null),
                    photoUrl: _selected!.photoPath != null
                        ? ref
                            .read(observationRepositoryProvider)
                            .photoUrl(_selected!.photoPath!)
                        : null,
                  ),
                ),
              if (points.isEmpty)
                Positioned(
                  top: 60,
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

class _ObservationCard extends StatelessWidget {
  const _ObservationCard({
    required this.observation,
    required this.lang,
    required this.onClose,
    this.photoUrl,
  });

  final Observation observation;
  final String lang;
  final VoidCallback onClose;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final name = observation.hasSpecies
        ? observation.displayNameFor(lang)
        : l.observationsUnknownSpecies;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  photoUrl!,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    width: 72,
                    height: 72,
                    child: Icon(Icons.broken_image),
                  ),
                ),
              )
            else
              const SizedBox(
                width: 72,
                height: 72,
                child: Icon(Icons.park, size: 40),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    l.observationsGps(
                      observation.latitude.toStringAsFixed(5),
                      observation.longitude.toStringAsFixed(5),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (observation.observedAt != null)
                    Text(
                      l.observationsDateTime(
                        observation.observedAt!.toLocal().toString(),
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
