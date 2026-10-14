import 'package:flutter/material.dart';

import '../core/locale_controller.dart';
import '../l10n/app_localizations.dart';
import '../legal/legal_texts.dart';
import 'delete_account_screen.dart';
import 'legal_screen.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final current = localeController.locale?.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l.settingsLanguage,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          // Rendszer nyelve
          RadioListTile<String?>(
            value: null,
            groupValue: current,
            onChanged: (v) {
              localeController.setLocale(null);
              setState(() {});
            },
            title: Text(l.settingsSystemLanguage),
          ),
          // Az összes támogatott nyelv
          ...AppLanguage.all.map(
            (lang) => RadioListTile<String?>(
              value: lang.code,
              groupValue: current,
              onChanged: (v) {
                localeController.setLocale(lang.code);
                setState(() {});
              },
              title: Text('${lang.flag}  ${lang.label}'),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),

          // ── Jogi dokumentumok ──────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l.legalPrivacy),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LegalScreen(doc: LegalDoc.privacy),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l.legalTerms),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LegalScreen(doc: LegalDoc.terms),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: Text(l.legalDeletion),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LegalScreen(doc: LegalDoc.deletion),
              ),
            ),
          ),

          const Divider(),

          // ── Fiók törlése ───────────────────────────────────────────
          ListTile(
            leading:
                const Icon(Icons.delete_forever, color: Color(0xFFB3261E)),
            title: Text(
              l.deleteAccountTitle,
              style: const TextStyle(color: Color(0xFFB3261E)),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const DeleteAccountScreen(),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
