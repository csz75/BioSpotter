import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/bounties/bounty_repository.dart';
import '../l10n/app_localizations.dart';
import 'bounty_create_screen.dart';
import 'bounty_detail_screen.dart';

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
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String _langCode() {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
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
          : TabBarView(
              controller: _tabs,
              children: [
                _list(_open, lang, l, emptyText: l.bountyEmpty),
                _list(_mine, lang, l, emptyText: l.bountyMineEmpty),
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
