import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/bounties/bounty_repository.dart';
import '../features/observations/observation.dart';
import '../l10n/app_localizations.dart';

/// Egy kitűzés részletei + beküldés.
class BountyDetailScreen extends ConsumerStatefulWidget {
  const BountyDetailScreen({super.key, required this.bounty});

  final Bounty bounty;

  @override
  ConsumerState<BountyDetailScreen> createState() =>
      _BountyDetailScreenState();
}

class _BountyDetailScreenState extends ConsumerState<BountyDetailScreen> {
  List<BountyClaim> _claims = const [];
  List<Observation> _mine = const [];
  List<String> _claimedObservationIds = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(bountyRepositoryProvider);
      final claims = await repo.claims(widget.bounty.id);
      final mine = await ref
          .read(observationRepositoryProvider)
          .fetchMine();
      if (!mounted) return;
      setState(() {
        _claims = claims;
        _mine = mine;
        _claimedObservationIds =
            claims.map((c) => c.observationId).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String _langCode() {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  /// Azok a megfigyeléseim, amik illenek a kitűzéshez.
  List<Observation> get _eligible {
    final b = widget.bounty;
    return _mine.where((o) {
      if (_claimedObservationIds.contains(o.id)) return false;
      if (b.speciesId != null && o.speciesId != b.speciesId) return false;
      return o.hasSpecies;
    }).toList();
  }

  Future<void> _claim() async {
    final l = AppLocalizations.of(context);
    final eligible = _eligible;

    if (eligible.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bountyNoEligible)),
      );
      return;
    }

    final lang = _langCode();
    final chosen = await showModalBottomSheet<Observation>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final maxHeight = MediaQuery.of(ctx).size.height * 0.7;
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
                  child: Text(l.bountyPickObservation,
                      style: Theme.of(ctx).textTheme.titleMedium),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: eligible.map((o) {
                      final listPath = o.listPhotoPath;
                      return ListTile(
                        leading: listPath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  ref
                                      .read(observationRepositoryProvider)
                                      .photoUrl(listPath),
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                              )
                            : const Icon(Icons.park),
                        title: Text(
                          o.hasSpecies
                              ? o.displayNameFor(lang)
                              : l.observationsUnknownSpecies,
                        ),
                        subtitle: Text(
                          o.observedAt != null
                              ? o.observedAt!
                                  .toLocal()
                                  .toString()
                                  .substring(0, 16)
                              : '',
                        ),
                        onTap: () => Navigator.of(ctx).pop(o),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );

    if (chosen == null) return;

    final err = await ref.read(bountyRepositoryProvider).claimBounty(
          bountyId: widget.bounty.id,
          observationId: chosen.id,
        );

    if (!mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.bountyClaimSent)),
    );
    await _load();
  }

  Future<void> _review(BountyClaim c, bool accept) async {
    final l = AppLocalizations.of(context);
    final err = await ref.read(bountyRepositoryProvider).reviewClaim(
          claimId: c.id,
          accept: accept,
        );
    if (!mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(accept ? l.bountyAccepted : l.bountyRejected)),
    );
    await _load();
  }

  /// A saját beküldéseim (a kitűző nem látja így).
  List<BountyClaim> get _myClaims {
    final uid = ref.read(supabaseClientProvider).auth.currentUser?.id;
    return _claims.where((c) => c.claimerId == uid).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final b = widget.bounty;
    final isCreator = b.isMine;

    return Scaffold(
      appBar: AppBar(title: Text(b.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Állapot
                if (b.isPendingApproval)
                  _banner(
                    Icons.hourglass_empty,
                    l.bountyStatusPending,
                    Colors.orange.shade100,
                  )
                else if (b.isPaid)
                  _banner(
                    Icons.check_circle,
                    l.bountyStatusPaid,
                    Colors.green.shade100,
                  )
                else if (b.isExpired)
                  _banner(
                    Icons.schedule,
                    l.bountyStatusExpired,
                    Colors.grey.shade200,
                  ),

                const SizedBox(height: 8),

                // Jutalom
                Row(
                  children: [
                    const Icon(Icons.stars, color: Color(0xFF1F3864)),
                    const SizedBox(width: 8),
                    Text(
                      '${b.rewardPoints} ${l.bountyPoints}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (b.scientificName != null)
                  Text(
                    b.commonNameHu != null && b.commonNameHu!.isNotEmpty
                        ? '${b.commonNameHu} · ${b.scientificName}'
                        : b.scientificName!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                if (b.description != null &&
                    b.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(b.description!),
                ],

                const SizedBox(height: 12),
                Text(
                  '${b.acceptedCount}/${b.maxWinners} ${l.bountySlots}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (b.expiresAt != null)
                  Text(
                    '${l.bountyExpires}: '
                    '${b.expiresAt!.toLocal().toString().substring(0, 10)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                const Divider(height: 32),

                // ── Beküldés — ha nyitott és nem a sajátom ──────────
                if (b.isOpen && !isCreator && !b.isExpired) ...[
                  FilledButton.icon(
                    icon: const Icon(Icons.send),
                    label: Text(l.bountySubmit),
                    onPressed: _claim,
                  ),
                  const SizedBox(height: 16),
                ],

                // ── A saját beküldéseim ─────────────────────────────
                if (!isCreator && _myClaims.isNotEmpty) ...[
                  Text(l.bountyMyClaims,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ..._myClaims.map((c) => _claimRow(c, l, canReview: false)),
                  const Divider(height: 32),
                ],

                // ── A kitűző nézete: a beküldések elbírálása ────────
                if (isCreator) ...[
                  Text(
                    '${l.bountyClaims} (${_claims.length})',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  if (_claims.isEmpty)
                    Text(l.bountyNoClaims,
                        style: Theme.of(context).textTheme.bodySmall)
                  else
                    ..._claims.map((c) => _claimRow(c, l, canReview: true)),
                ],

                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _banner(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _claimRow(
    BountyClaim c,
    AppLocalizations l, {
    required bool canReview,
  }) {
    final photoUrl = c.photoPath != null
        ? ref.read(bountyRepositoryProvider).photoUrl(c.photoPath!)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (photoUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                photoUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const SizedBox(width: 48, height: 48),
              ),
            )
          else
            const SizedBox(width: 48, height: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.scientificName ?? l.observationsUnknownSpecies),
                Text(
                  _statusText(c, l),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (canReview && c.isPending) ...[
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              tooltip: l.bountyAccept,
              onPressed: () => _review(c, true),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              tooltip: l.bountyReject,
              onPressed: () => _review(c, false),
            ),
          ],
        ],
      ),
    );
  }

  String _statusText(BountyClaim c, AppLocalizations l) {
    switch (c.status) {
      case 'accepted':
        return l.bountyClaimAccepted;
      case 'rejected':
        return l.bountyClaimRejected;
      default:
        return l.bountyClaimPending;
    }
  }
}
