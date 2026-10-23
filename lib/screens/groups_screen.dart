import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../features/groups/group_repository.dart';
import '../l10n/app_localizations.dart';
import 'group_detail_screen.dart';

/// A felhasználó csoportjai.
class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  List<Group> _groups = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final groups = await ref.read(groupRepositoryProvider).myGroups();
    if (!mounted) return;
    setState(() {
      _groups = groups;
      _loading = false;
    });
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
          : _groups.isEmpty
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
              : ListView.separated(
                  itemCount: _groups.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final g = _groups[i];
                    return ListTile(
                      leading: Icon(
                        g.isOwner ? Icons.workspace_premium : Icons.group,
                        color: g.isOwner ? const Color(0xFF1F3864) : null,
                      ),
                      title: Text(g.name),
                      subtitle: g.description != null
                          ? Text(g.description!)
                          : null,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GroupDetailScreen(group: g),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
