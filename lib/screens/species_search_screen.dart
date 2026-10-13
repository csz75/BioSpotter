import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/identification/col_match.dart';
import '../l10n/app_localizations.dart';

/// A GBIF-alapú fajnév-kereső.
/// Élő keresés (400 ms késleltetéssel), nyelv-választóval,
/// és a kiválasztott faj visszaadásával (`Navigator.pop(match)`).
class SpeciesSearchScreen extends ConsumerStatefulWidget {
  const SpeciesSearchScreen({super.key});

  @override
  ConsumerState<SpeciesSearchScreen> createState() =>
      _SpeciesSearchScreenState();
}

class _SpeciesSearchScreenState extends ConsumerState<SpeciesSearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  Timer? _debounce;
  List<ColMatch> _results = const [];
  bool _loading = false;
  bool _searched = false;

  /// A keresés nyelve — alapból az app nyelve, de átváltható.
  late String _lang;

  @override
  void initState() {
    super.initState();
    _lang = _currentAppLang();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  String _currentAppLang() {
    final code = localeController.locale?.languageCode;
    if (code != null) return _toColLang(code);
    final sys = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return _toColLang(sys);
  }

  /// Az app ISO 639-1 kódját ISO 639-3-ra váltja (a GBIF ezt használja).
  String _toColLang(String code) {
    switch (code) {
      case 'hu':
        return 'hun';
      case 'en':
        return 'eng';
      case 'de':
        return 'deu';
      case 'fr':
        return 'fra';
      case 'es':
        return 'spa';
      case 'it':
        return 'ita';
      case 'pl':
        return 'pol';
      default:
        return 'eng';
    }
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() {
        _results = const [];
        _searched = false;
        _loading = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _runSearch(value);
    });
  }

  Future<void> _runSearch(String query) async {
    final q = query.trim();
    if (q.length < 2) return;

    setState(() => _loading = true);
    final matches = await ref
        .read(colSearchServiceProvider)
        .search(query: q, language: _lang);

    if (!mounted) return;
    setState(() {
      _results = matches;
      _loading = false;
      _searched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.searchTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              onSubmitted: _runSearch,
              decoration: InputDecoration(
                hintText: l.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _onChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.translate, size: 18),
                const SizedBox(width: 8),
                Text(l.searchLanguage,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: AppLanguage.all.map((lang) {
                        final code = _toColLang(lang.code);
                        final selected = code == _lang;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text('${lang.flag} ${lang.code.toUpperCase()}'),
                            selected: selected,
                            onSelected: (_) {
                              setState(() => _lang = code);
                              if (_controller.text.trim().length >= 2) {
                                _runSearch(_controller.text);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 16),
          Expanded(child: _buildResults(l)),
        ],
      ),
    );
  }

  Widget _buildResults(AppLocalizations l) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_searched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l.searchStartHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off, size: 48),
              const SizedBox(height: 12),
              Text(l.searchNoResults, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                l.searchTryOtherLanguage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final m = _results[i];
        final localized = m.vernacularNames[_lang];
        final title = localized ?? m.scientificName ?? '?';
        final isDifferent =
            localized != null && localized != m.scientificName;

        return ListTile(
          leading: Icon(_iconForKingdom(m.kingdom)),
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDifferent)
                Text(
                  m.scientificName ?? '',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              if (m.family != null)
                Text(
                  m.family!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          isThreeLine: isDifferent && m.family != null,
          onTap: () => Navigator.of(context).pop(m),
        );
      },
    );
  }

  IconData _iconForKingdom(String? kingdom) {
    switch (kingdom) {
      case 'Animalia':
        return Icons.pets;
      case 'Plantae':
        return Icons.local_florist;
      case 'Fungi':
        return Icons.eco;
      default:
        return Icons.category;
    }
  }
}
