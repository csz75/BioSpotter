import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/groups/group_repository.dart';
import '../features/observations/observation.dart';
import '../l10n/app_localizations.dart';
import '../widgets/observation_detail_sheet.dart';

/// Egy csoport részletei: meghívó kód + a tagok megfigyelései.
class GroupDetailScreen extends ConsumerStatefulWidget {
  const GroupDetailScreen({super.key, required this.group});

  final Group group;

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  List<Observation> _observations = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
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

  String _langCode() {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = _langCode();

    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: Column(
        children: [
          // Meghívó kód sáv
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
                          child: Text(l.groupEmpty, textAlign: TextAlign.center),
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
