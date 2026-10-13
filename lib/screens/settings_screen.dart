import 'package:flutter/material.dart';

import '../core/locale_controller.dart';
import '../l10n/app_localizations.dart';
import 'delete_account_screen.dart';

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

          // Fiók törlése — a review előtt kötelező
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
        ],
      ),
    );
  }
}
