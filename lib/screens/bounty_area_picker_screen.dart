import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../l10n/app_localizations.dart';

/// A kiválasztott terület — a középpont és a sugár (km).
class BountyArea {
  const BountyArea({required this.center, required this.radiusKm});

  final LatLng center;
  final double radiusKm;
}

/// Térképes terület-választó — koppintással jelöli ki a középpontot,
/// csúszkával a sugarat. `Navigator.pop(area)`-val adja vissza az eredményt.
class BountyAreaPickerScreen extends StatefulWidget {
  const BountyAreaPickerScreen({super.key, this.initial});

  final BountyArea? initial;

  @override
  State<BountyAreaPickerScreen> createState() =>
      _BountyAreaPickerScreenState();
}

class _BountyAreaPickerScreenState extends State<BountyAreaPickerScreen> {
  static const _fallbackCenter = LatLng(47.1625, 19.5033);

  LatLng? _center;
  double _radiusKm = 10;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _center = widget.initial?.center;
    _radiusKm = widget.initial?.radiusKm ?? 10;
  }

  Future<void> _useMyLocation() async {
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      if (!mounted) return;
      setState(() => _center = LatLng(pos.latitude, pos.longitude));
    } catch (_) {
      // Csendben figyelmen kívül hagyjuk — a felhasználó koppinthat kézzel.
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _confirm() {
    final l = AppLocalizations.of(context);
    final center = _center;
    if (center == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bountyAreaPickerNoCenter)),
      );
      return;
    }
    Navigator.of(context).pop(BountyArea(center: center, radiusKm: _radiusKm));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.bountyAreaPickerTitle),
        actions: [
          TextButton(
            onPressed: _confirm,
            child: Text(
              l.bountyAreaPickerConfirm,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: _center ?? _fallbackCenter,
                    initialZoom: _center != null ? 11 : 7,
                    onTap: (_, point) => setState(() => _center = point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'hu.therma.biospotter',
                    ),
                    if (_center != null)
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: _center!,
                            radius: _radiusKm * 1000,
                            useRadiusInMeter: true,
                            color: const Color(0xFF1F3864).withValues(alpha: 0.15),
                            borderColor: const Color(0xFF1F3864),
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                    if (_center != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _center!,
                            width: 32,
                            height: 32,
                            child: const Icon(
                              Icons.location_on,
                              size: 32,
                              color: Color(0xFF1F3864),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.touch_app, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l.bountyAreaPickerHint,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: _locating ? null : _useMyLocation,
                    tooltip: l.bountyAreaPickerUseLocation,
                    child: _locating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _radiusKm,
                    min: 1,
                    max: 100,
                    divisions: 99,
                    label: '${_radiusKm.round()} km',
                    onChanged: (v) => setState(() => _radiusKm = v),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    l.bountyAreaPickerRadius('${_radiusKm.round()}'),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
