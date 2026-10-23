import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../features/groups/group_repository.dart';
import '../l10n/app_localizations.dart';
import 'group_detail_screen.dart';

/// A felhasználó csoportjai — az aktívak és (ownernek) az archiváltak.
class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  List<Group> _groups = const [];
  List<Group> _archived = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(groupRepositoryProvider);
      final groups = await repo.myGroups();
      final archived = await repo.myArchivedGroups();
      if (!mounted) return;
      setState(() {
        _groups = groups;
        _archived = archived;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _restore(Group g) async {
    final l = AppLocalizations.of(context);
    try {
      await ref.read(groupRepositoryProvider).restoreGroup(g.id);
      if (!mounted) return;
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.groupRestored)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loginError(''))),
      );
    }
  }

  Future<void> _create() async {
    final l = AppLocalizations.of(context);
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.groupsCreate),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: InputDecoration(labelText: l.groupsName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(labelText: l.groupsDescription),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.reportCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.groupsCreateButton),
          ),
        ],
      ),
    );

    if (ok != true) return;
    final name = nameCtrl.text.trim();
    if (name.isEmpty) return;

    try {
      await ref.read(groupRepositoryProvider).createGroup(
            name: name,
            description: descCtrl.text.trim().isEmpty
                ? null
                : descCtrl.text.trim(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.groupsCreated)),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loginError('$e'))),
      );
    }
  }

  Future<void> _join() async {
    final l = AppLocalizations.of(context);
    final codeCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.groupsJoin),
        content: TextField(
          controller: codeCtrl,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: l.groupsInviteCode,
            hintText: l.groupsJoinHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.reportCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.groupsJoinButton),
          ),
        ],
      ),
    );

    if (ok != true) return;
    final code = codeCtrl.text.trim();
    if (code.isEmpty) return;

    try {
      await ref.read(groupRepositoryProvider).joinGroup(code);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.groupsJoined)),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.groupsInvalidCode)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasAny = _groups.isNotEmpty || _archived.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.groupsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        icon: const Icon(Icons.group_add),
        label: Text(l.groupsCreate),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !hasAny
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.groups_outlined, size: 56),
                        const SizedBox(height: 12),
                        Text(l.groupsEmpty, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.login),
                          label: Text(l.groupsJoin),
                          onPressed: _join,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  children: [
                    // ── Aktív csoportok ──────────────────────────────
                    ..._groups.map((g) => _groupTile(g, l)),

                    // ── Archivált (csak owner) ───────────────────────
                    if (_archived.isNotEmpty) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          l.groupArchivedSection,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      ..._archived.map((g) => _groupTile(g, l)),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
    );
  }

  Widget _groupTile(Group g, AppLocalizations l) {
    final archived = g.isArchived;

    return ListTile(
      leading: Icon(
        archived
            ? Icons.archive_outlined
            : (g.isOwner ? Icons.workspace_premium : Icons.group),
        color: archived
            ? Colors.grey
            : (g.isOwner ? const Color(0xFF1F3864) : null),
      ),
      title: Text(g.name),
      subtitle: archived
          ? Text(l.groupArchived)
          : (g.description != null ? Text(g.description!) : null),
      trailing: archived
          ? IconButton(
              icon: const Icon(Icons.restore),
              tooltip: l.groupRestore,
              onPressed: () => _restore(g),
            )
          : const Icon(Icons.chevron_right),
      onTap: archived
          ? null
          : () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GroupDetailScreen(group: g),
                ),
              ),
    );
  }
}
