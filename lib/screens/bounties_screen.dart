import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/bounties/bounty_repository.dart';
import '../l10n/app_localizations.dart';
import 'bounty_create_screen.dart';
import 'bounty_detail_screen.dart';
import 'premium_screen.dart';

/// A nyitott kitűzések listája.
class BountiesScreen extends ConsumerStatefulWidget {
  const BountiesScreen({super.key});

  @override
  ConsumerState<BountiesScreen> createState() => _BountiesScreenState();
}

class _BountiesScreenState extends ConsumerState<BountiesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  List<Bounty> _open = const [];
  List<Bounty> _mine = const [];
  bool _loading = true;

  /// Csak az aktív (nem lejárt) határidejű kitűzéseket mutassa.
  bool _activeOnly = false;

  /// A "Közelemben" szűrő sugara km-ben (null = kikapcsolva).
  static const _nearbyOptions = [10.0, 25.0, 50.0, 100.0];
  double? _nearbyKm;
  Position? _myPosition;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(bountyRepositoryProvider);
      final open = await repo.openBounties();
      final mine = await repo.myBounties();
      if (!mounted) return;
      setState(() {
        _open = open;
        _mine = mine;
        _loading = false;
      });
      // A lista megnyit\u00e1sa jelzi, hogy a felhaszn\u00e1l\u00f3 l\u00e1tta a kit\u0171z\u00e9seket \u2014
      // ett\u0151l kezdve \u00faj badge csak a mostant\u00f3l l\u00e9trej\u00f6v\u0151 kit\u0171z\u00e9sekre jelenik meg.
      unawaited(repo.markBountiesChecked());
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String _langCode() {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  /// A jelenlegi helyzet lekérése a "Közelemben" szűrőhöz.
  /// Visszatérés: sikerült-e.
  Future<bool> _determinePosition() async {
    final l = AppLocalizations.of(context);
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showLocationError(l.locationServiceDisabled);
        return false;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        _showLocationError(l.locationPermissionDenied);
        return false;
      }
      if (permission == LocationPermission.deniedForever) {
        _showLocationError(l.locationPermissionDeniedForever);
        return false;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      if (!mounted) return false;
      setState(() => _myPosition = pos);
      return true;
    } catch (_) {
      _showLocationError(l.locationUnavailable);
      return false;
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _showLocationError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// A "Közelemben" chip kiválasztása/kikapcsolása.
  Future<void> _toggleNearby(double km) async {
    if (_nearbyKm == km) {
      setState(() => _nearbyKm = null);
      return;
    }
    if (_myPosition == null) {
      final ok = await _determinePosition();
      if (!ok) return;
    }
    if (!mounted) return;
    setState(() => _nearbyKm = km);
  }

  /// A szűrők alkalmazása a listára.
  List<Bounty> _applyFilters(List<Bounty> items) {
    var result = items;
    if (_activeOnly) {
      result = result.where((b) => !b.isExpired).toList();
    }
    final km = _nearbyKm;
    final pos = _myPosition;
    if (km != null && pos != null) {
      result = result.where((b) {
        if (!b.hasArea) return false;
        final distanceKm = Geolocator.distanceBetween(
              pos.latitude,
              pos.longitude,
              b.latitude!,
              b.longitude!,
            ) /
            1000;
        return distanceKm <= km;
      }).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = _langCode();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.bountyTitle),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l.bountyTabOpen),
            Tab(text: l.bountyTabMine),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Kitűzés létrehozásához prémium előfizetés kell (a beküldés marad ingyenes).
          final isPremium = await ref.read(premiumProvider.future);
          if (!mounted) return;
          if (!isPremium) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PremiumScreen()),
            );
            return;
          }
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const BountyCreateScreen()),
          );
          if (mounted) await _load();
        },
        icon: const Icon(Icons.add),
        label: Text(l.bountyCreate),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: Text(l.bountyFilterActiveOnly),
                          selected: _activeOnly,
                          onSelected: (v) => setState(() => _activeOnly = v),
                        ),
                        const SizedBox(width: 8),
                        ..._nearbyOptions.map((km) => Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: FilterChip(
                                avatar: _locating && _nearbyKm != km
                                    ? null
                                    : const Icon(Icons.near_me, size: 16),
                                label: Text(
                                  l.bountyFilterNearbyKm('${km.round()}'),
                                ),
                                selected: _nearbyKm == km,
                                onSelected: (_) => _toggleNearby(km),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      _list(_applyFilters(_open), lang, l,
                          emptyText: _activeOnly || _nearbyKm != null
                              ? l.bountyFilterNoneFound
                              : l.bountyEmpty),
                      _list(_applyFilters(_mine), lang, l,
                          emptyText: _activeOnly || _nearbyKm != null
                              ? l.bountyFilterNoneFound
                              : l.bountyMineEmpty),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _list(
    List<Bounty> items,
    String lang,
    AppLocalizations l, {
    required String emptyText,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(emptyText, textAlign: TextAlign.center),
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final b = items[i];
        return ListTile(
          leading: _statusIcon(b),
          title: Text(b.title),
          subtitle: Text(_subtitle(b, l)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BountyDetailScreen(bounty: b),
              ),
            );
            if (mounted) await _load();
          },
        );
      },
    );
  }

  Widget _statusIcon(Bounty b) {
    if (b.isPendingApproval) {
      return const Icon(Icons.hourglass_empty, color: Colors.orange);
    }
    if (b.isPaid) {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
    return const Icon(Icons.track_changes, color: Color(0xFF1F3864));
  }

  String _subtitle(Bounty b, AppLocalizations l) {
    final parts = <String>[];
    if (b.commonNameHu != null && b.commonNameHu!.isNotEmpty) {
      parts.add(b.commonNameHu!);
    } else if (b.scientificName != null) {
      parts.add(b.scientificName!);
    }
    parts.add('${b.rewardPoints} ${l.bountyPoints}');
    parts.add('${b.slotsLeft}/${b.maxWinners} ${l.bountySlots}');

    if (b.isPendingApproval) {
      parts.add(l.bountyStatusPending);
    } else if (b.isPaid) {
      parts.add(l.bountyStatusPaid);
    } else if (b.isExpired) {
      parts.add(l.bountyStatusExpired);
    } else if (b.expiresAt != null) {
      final days = b.expiresAt!.difference(DateTime.now()).inDays;
      parts.add(days > 0 ? l.bountyDaysLeft(days) : l.bountyStatusExpired);
    }
    return parts.join(' · ');
  }
}
