import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../l10n/app_localizations.dart';
import 'observation_list_screen.dart';

/// Fiók törlése — valójában anonimizálás.
///
///  • a név és az e-mail véletlen azonosítóra cserélődik
///  • a régi e-mail felszabadul → ugyanazzal a címmel újra lehet regisztrálni
///  • a jelszó véletlenre cserélődik → a belépés megszűnik
///  • a megfigyelések anonim formában megmaradnak
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  bool _confirmed = false;
  bool _busy = false;

  Future<void> _delete() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);

    try {
      final res = await Supabase.instance.client.functions.invoke(
        'delete-account',
      );

      if (res.status != 200) {
        final msg = (res.data is Map && res.data['error'] != null)
            ? '${res.data['error']}'
            : l.deleteAccountFailed;
        if (!mounted) return;
        setState(() => _busy = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
        return;
      }

      // Siker: kijelentkeztetés.
      await Supabase.instance.client.auth.signOut();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.deleteAccountDone)),
      );
      Navigator.of(context).popUntil((r) => r.isFirst);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.deleteAccountFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.deleteAccountTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Icon(Icons.warning_amber_rounded,
                    size: 56, color: Color(0xFFB3261E)),
              ),
              const SizedBox(height: 16),
              Text(
                l.deleteAccountHeading,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(l.deleteAccountBody1),
              const SizedBox(height: 12),
              Text(l.deleteAccountBody2),
              const SizedBox(height: 20),

              // Ugrás a saját megfigyelésekhez — kézi törléshez.
              OutlinedButton.icon(
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l.deleteAccountOpenMine),
                onPressed: _busy
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ObservationListScreen(),
                          ),
                        ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),

              CheckboxListTile(
                value: _confirmed,
                onChanged: _busy
                    ? null
                    : (v) => setState(() => _confirmed = v ?? false),
                title: Text(l.deleteAccountConfirm),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _busy ? null : () => Navigator.of(context).pop(),
                      child: Text(l.deleteAccountCancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: _busy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.delete_forever),
                      label: Text(l.deleteAccountButton),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFB3261E),
                      ),
                      onPressed: (_confirmed && !_busy) ? _delete : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
