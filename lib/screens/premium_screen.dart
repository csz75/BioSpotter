import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../l10n/app_localizations.dart';

/// Prémium előfizetés kezelése — feliratkozás és lemondás.
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool? _isPremium;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _checkPremium();
  }

  Future<void> _checkPremium() async {
    final premium = await ref.read(searchRepositoryProvider).isPremium();
    if (mounted) setState(() => _isPremium = premium);
  }

  Future<void> _enableTestPremium() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.premiumTestTitle),
        content: Text(l.premiumTestBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.reportCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.premiumSubscribe),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    final err = await ref.read(searchRepositoryProvider).activateTestPremium();
    if (!mounted) return;
    setState(() => _busy = false);

    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    // A közös prémium állapot érvénytelenítése — a Térkép azonnal frissül.
    ref.invalidate(premiumProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.premiumActivated)),
    );
    await _checkPremium();
  }

  Future<void> _disableTestPremium() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    final err = await ref.read(searchRepositoryProvider).deactivatePremium();
    if (!mounted) return;
    setState(() => _busy = false);

    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    // A közös prémium állapot érvénytelenítése — a Térkép azonnal frissül.
    ref.invalidate(premiumProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.premiumDeactivated)),
    );
    await _checkPremium();
  }

  Widget _featureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 20, color: Color(0xFF3A6B4A)),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.premiumScreenTitle)),
      body: _isPremium == null
          ? const Center(child: CircularProgressIndicator())
          : _isPremium == true
              ? _activeView(l)
              : _paywallView(l),
    );
  }

  // ── Aktív előfizetés ────────────────────────────────────────────────

  Widget _activeView(AppLocalizations l) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.workspace_premium,
                      size: 56, color: Color(0xFF1F3864)),
                  const SizedBox(height: 12),
                  Text(
                    l.premiumActive,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    icon: const Icon(Icons.cancel_outlined),
                    label: Text(l.premiumDeactivate),
                    onPressed: _busy ? null : _disableTestPremium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Díjtábla (fizetés előtti állapot) ──────────────────────────────

  Widget _paywallView(AppLocalizations l) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.workspace_premium,
                      size: 56, color: Color(0xFF1F3864)),
                  const SizedBox(height: 12),
                  Text(
                    l.premiumTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.premiumSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  _featureRow(l.premiumFeature1),
                  _featureRow(l.premiumFeature2),
                  _featureRow(l.premiumFeature3),
                  const SizedBox(height: 20),
                  Text(
                    l.premiumPrice,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.star),
                    label: Text(l.premiumSubscribe),
                    onPressed: _busy ? null : _enableTestPremium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.premiumTestNote,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
