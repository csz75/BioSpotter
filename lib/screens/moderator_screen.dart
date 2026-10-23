import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../features/moderator/moderator_repository.dart';
import '../l10n/app_localizations.dart';

/// Moderátor képernyő — két fül: függő kitűzések és bejelentett megfigyelések.
class ModeratorScreen extends ConsumerStatefulWidget {
  const ModeratorScreen({super.key});

  @override
  ConsumerState<ModeratorScreen> createState() => _ModeratorScreenState();
}

class _ModeratorScreenState extends ConsumerState<ModeratorScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  List<PendingBounty> _bounties = const [];
  List<FlaggedObservation> _flagged = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
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
      final repo = ref.read(moderatorRepositoryProvider);
      final bounties = await repo.pendingBounties();
      final flagged = await repo.flaggedObservations();
      if (!mounted) return;
      setState(() {
        _bounties = bounties;
        _flagged = flagged;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _approve(PendingBounty b) async {
    final l = AppLocalizations.of(context);
    final err = await ref
        .read(moderatorRepositoryProvider)
        .approveBounty(b.id);
    if (!mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.moderatorBountyApproved)),
    );
    await _load();
  }

  Future<void> _rejectBounty(PendingBounty b) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.moderatorRejectBounty),
        content: Text(l.moderatorRejectBountyBody(b.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.reportCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.moderatorReject),
          ),
        ],
      ),
    );
    if (ok != true) return;

    // A kitűzés elutasítása = 'cancelled' státusz
    final err = await ref
        .read(moderatorRepositoryProvider)
        .moderateBountyReject(b.id);
    if (!mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.moderatorBountyRejected)),
    );
    await _load();
  }

  Future<void> _moderate(FlaggedObservation o, String action) async {
    final l = AppLocalizations.of(context);
    final err = await ref
        .read(moderatorRepositoryProvider)
        .moderateObservation(observationId: o.id, action: action);
    if (!mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          action == 'publish'
              ? l.moderatorObsPublished
              : l.moderatorObsRejected,
        ),
      ),
    );
    await _load();
  }

  /// A bejelentés okának olvasható szövege.
  String _reasonLabel(String reasons, AppLocalizations l) {
    if (reasons.trim().isEmpty) return l.moderatorNoReason;
    final parts = reasons.split(',').map((r) => r.trim());
    return parts.map((r) {
      switch (r) {
        case 'not_nature':
          return l.reportNotNature;
        case 'violent':
          return l.reportViolent;
        case 'adult':
          return l.reportAdult;
        case 'other':
          return l.reportOther;
        default:
          return r;
      }
    }).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.moderatorTitle),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(
              text: '${l.moderatorTabBounties}'
                  '${_bounties.isNotEmpty ? ' (${_bounties.length})' : ''}',
            ),
            Tab(
              text: '${l.moderatorTabReports}'
                  '${_flagged.isNotEmpty ? ' (${_flagged.length})' : ''}',
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [
                _bountyTab(l),
                _reportTab(l),
              ],
            ),
    );
  }

  // ── Függő kitűzések ─────────────────────────────────────────────────

  Widget _bountyTab(AppLocalizations l) {
    if (_bounties.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l.moderatorNoBounties, textAlign: TextAlign.center),
        ),
      );
    }

    return ListView.separated(
      itemCount: _bounties.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final b = _bounties[i];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(b.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                '${b.rewardPoints} ${l.bountyPoints} · '
                '${b.maxWinners} ${l.bountySlots}'
                '${b.creatorEmail != null ? ' · ${b.creatorEmail}' : ''}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (b.description != null &&
                  b.description!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(b.description!),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      icon: const Icon(Icons.close),
                      label: Text(l.moderatorReject),
                      onPressed: () => _rejectBounty(b),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(l.moderatorApprove),
                      onPressed: () => _approve(b),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Bejelentett megfigyelések ───────────────────────────────────────

  Widget _reportTab(AppLocalizations l) {
    if (_flagged.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l.moderatorNoReports, textAlign: TextAlign.center),
        ),
      );
    }

    return ListView.separated(
      itemCount: _flagged.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final o = _flagged[i];
        final path = o.photoPath ?? o.thumbPath;
        final photoUrl = path != null
            ? ref.read(moderatorRepositoryProvider).photoUrl(path)
            : null;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (photoUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    photoUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 120,
                      child: Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                o.commonNameHu ??
                    o.scientificName ??
                    l.observationsUnknownSpecies,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (o.scientificName != null && o.commonNameHu != null) ...[
                const SizedBox(height: 2),
                Text(
                  o.scientificName!,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                '${o.latitude.toStringAsFixed(5)}, '
                '${o.longitude.toStringAsFixed(5)}'
                '${o.observedAt != null ? ' · ${o.observedAt!.toLocal().toString().substring(0, 16)}' : ''}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.flag, size: 16, color: Colors.red.shade700),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${l.moderatorReportReason}: '
                      '${_reasonLabel(o.reasons, l)}'
                      '${o.reportCount > 1 ? ' (${o.reportCount}×)' : ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      icon: const Icon(Icons.block),
                      label: Text(l.moderatorObsReject),
                      onPressed: () => _moderate(o, 'reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(l.moderatorObsPublish),
                      onPressed: () => _moderate(o, 'publish'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
