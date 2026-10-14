import 'package:flutter/material.dart';

import '../core/locale_controller.dart';
import '../l10n/app_localizations.dart';
import '../legal/legal_texts.dart';

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key, required this.doc});

  final LegalDoc doc;

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  String get _lang =>
      localeController.locale?.languageCode ??
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;

  String _title(AppLocalizations l) {
    switch (widget.doc) {
      case LegalDoc.privacy:
        return l.legalPrivacy;
      case LegalDoc.terms:
        return l.legalTerms;
      case LegalDoc.deletion:
        return l.legalDeletion;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final blocks = legalBlocks(widget.doc, _lang);

    return Scaffold(
      appBar: AppBar(title: Text(_title(l))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
        children: [
          ...blocks.expand((b) => [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 8),
                  child: Text(
                    b.$1,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                ...b.$2.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(p, style: const TextStyle(height: 1.5)),
                    )),
              ]),
          const Divider(height: 40),
          Text(
            'BioSpotter · Therma Kft. · 1098 Budapest, Friss utca 3.\n'
            'szabolcs.csoke@thermakft.hu',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
