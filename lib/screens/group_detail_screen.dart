import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/groups/group_repository.dart';
import '../features/observations/observation.dart';
import '../l10n/app_localizations.dart';
import '../widgets/observation_detail_sheet.dart';

/// Egy csoport részletei: meghívó kód, tagok és a tagok megfigyelései.
class GroupDetailScreen extends ConsumerStatefulWidget {
  const GroupDetailScreen({super.key, required this.group});

  final Group group;

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  List<Observation> _observations = const [];
  List<GroupMember> _members = const [];
  bool _loading = true;
  bool _membersLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _loadMembers();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final items = await ref
          .read(groupRepositoryProvider)
          .groupObservations(widget.group.id);
      if (!mounted) return;
      setState(() {
        _observations = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _loadMembers() async {
    setState(() => _membersLoading = true);
    try {
      final members = await ref
          .read(groupRepositoryProvider)
          .members(widget.group.id);
      if (!mounted) return;
      setState(() {
        _members = members;
        _membersLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _membersLoading = false);
    }
  }

  Future<void> _reloadAll() async {
    await Future.wait([_load(), _loadMembers()]);
  }

  String _langCode() {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  // ── Tagok lap ────────────────────────────────────────────────────────

  void _showMembers() {
    final l = AppLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.35,
        maxChildSize: 0.9,
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
              Text(
                '${l.groupMembersTitle} (${_members.length})',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (_membersLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                ..._members.map(
                  (m) => ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        m.displayName.isNotEmpty
                            ? m.displayName[0].toUpperCase()
                            : '?',
                      ),
                    ),
                    title: Text(m.displayName),
                    subtitle: m.isOwner
                        ? Text(l.groupMemberOwner)
                        : null,
                    trailing: (widget.group.isOwner && !m.isOwner)
                        ? IconButton(
                            icon: const Icon(Icons.person_remove_outlined),
                            tooltip: l.groupRemoveMember,
                            onPressed: () => _confirmRemoveMember(m),
                          )
                        : null,
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmRemoveMember(GroupMember m) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.groupRemoveMember),
        content: Text(l.groupRemoveMemberBody(m.displayName)),
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
            child: Text(l.groupRemoveMember),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref
          .read(groupRepositoryProvider)
          .removeMember(widget.group.id, m.userId);
      if (!mounted) return;
      await _reloadAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.groupMemberRemoved)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loginError(''))),
      );
    }
  }

  // ── Kilépés / archiválás ─────────────────────────────────────────────

  Future<void> _leave() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.groupLeave),
        content: Text(l.groupLeaveBody),
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
            child: Text(l.groupLeave),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref.read(groupRepositoryProvider).leaveGroup(widget.group.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loginError(''))),
      );
    }
  }

  Future<void> _archive() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.groupArchive),
        content: Text(l.groupArchiveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.reportCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.groupArchive),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref.read(groupRepositoryProvider).archiveGroup(widget.group.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loginError(''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = _langCode();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadAll,
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'leave') _leave();
              if (v == 'archive') _archive();
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'leave',
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 18),
                    const SizedBox(width: 12),
                    Text(l.groupLeave),
                  ],
                ),
              ),
              if (widget.group.isOwner)
                PopupMenuItem(
                  value: 'archive',
                  child: Row(
                    children: [
                      const Icon(Icons.archive_outlined, size: 18),
                      const SizedBox(width: 12),
                      Text(l.groupArchive),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Meghívó kód + tagok gomb
          Container(
            color: const Color(0xFFE8EEF7),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.key, size: 18, color: Color(0xFF1F3864)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${l.groupInviteCodeLabel}: ${widget.group.inviteCode}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  tooltip: l.groupCopyCode,
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.group.inviteCode),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.groupCodeCopied)),
                    );
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.people_outline, size: 18),
                  label: Text('${_members.length}'),
                  onPressed: _showMembers,
                ),
              ],
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _observations.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(l.groupEmpty,
                              textAlign: TextAlign.center),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _observations.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final o = _observations[i];
                          final name = o.hasSpecies
                              ? o.displayNameFor(lang)
                              : l.observationsUnknownSpecies;
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
                                      errorBuilder: (_, __, ___) =>
                                          const SizedBox(
                                        width: 56,
                                        height: 56,
                                        child: Icon(Icons.broken_image),
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.park),
                            title: Text(name),
                            subtitle: Text(
                              o.observedAt != null
                                  ? o.observedAt!
                                      .toLocal()
                                      .toString()
                                      .substring(0, 16)
                                  : '',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => showObservationDetail(
                              context,
                              ref,
                              o,
                              lang,
                              allowLike: true,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
