import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/observations/observation.dart';
import '../features/search/observation_filter.dart';
import '../l10n/app_localizations.dart';

/// Megfigyelés-keresés — két mód:
///  • Saját      — a bejelentkezett felhasználó megfigyelései (kliens-oldali szűrés)
///  • Közösségi  — mindenki megfigyelései (szerveroldali szűrés, prémium)
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  final _controller = TextEditingController();

  ObservationFilter _filter = const ObservationFilter();

  // Saját mód
  List<Observation> _mine = const [];
  bool _loadingMine = true;
  String? _errorMine;

  // Közösségi mód
  List<Observation> _community = const [];
  bool _loadingCommunity = false;
  String? _errorCommunity;
  bool? _isPremium;

  /// A közösségi fül szerveroldali újratöltésének késleltetése —
  /// így gépelés közben nem indul minden leütésre külön RPC-hívás.
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) {
        setState(() {});
        // Fülváltásnál a közösségi lista újratöltése az aktuális szűrővel.
        if (_tabs.index == 1 && _isPremium == true) _loadCommunity();
      }
    });
    _loadMine();
    _checkPremium();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabs.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ── Betöltések ──────────────────────────────────────────────────────

  Future<void> _loadMine() async {
    setState(() {
      _loadingMine = true;
      _errorMine = null;
    });
    try {
      final items =
          await ref.read(observationRepositoryProvider).fetchMine();
      if (!mounted) return;
      setState(() {
        _mine = items;
        _loadingMine = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMine = '$e';
        _loadingMine = false;
      });
    }
  }

  Future<void> _checkPremium() async {
    final premium = await ref.read(searchRepositoryProvider).isPremium();
    if (!mounted) return;
    setState(() => _isPremium = premium);
  }

  Future<void> _loadCommunity() async {
    setState(() {
      _loadingCommunity = true;
      _errorCommunity = null;
    });
    try {
      final items =
          await ref.read(searchRepositoryProvider).loadCommunity(_filter);
      if (!mounted) return;
      setState(() {
        _community = items;
        _loadingCommunity = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorCommunity = '$e';
        _loadingCommunity = false;
      });
    }
  }

  // ── Segédek ─────────────────────────────────────────────────────────

  /// Szűrőváltozás kezelése: állapotfrissítés, és ha a közösségi fül
  /// az aktív, a szerveroldali találatok újratöltése (késleltetve).
  ///
  /// A saját fül kliens-oldalon szűr (a `_mineResults` getter minden
  /// újraépítésnél újraszámol), ezért ott nincs szükség szerverhívásra.
  void _onFilterChanged(VoidCallback apply) {
    setState(apply);

    if (_tabs.index != 1) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _loadCommunity();
    });
  }

  String _langCode() {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  List<String> _namesOf(Observation o) {
    final names = <String>[];
    if (o.scientificName != null) names.add(o.scientificName!);
    if (o.commonNameHu != null) names.add(o.commonNameHu!);
    names.addAll(o.vernacularNames.values);
    return names;
  }

  List<Observation> get _mineResults {
    if (_filter.isEmpty) return _mine;
    return _mine
        .where((o) => _filter.matches(o, searchNames: _namesOf(o)))
        .toList();
  }

  /// Fejlesztői teszt: prémium bekapcsolása fizetés nélkül.
  /// Éles verzióban ezt a Stripe Checkout váltja fel — a UI marad.
  Future<void> _enableTestPremium() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx).premiumTestTitle),
        content: Text(AppLocalizations.of(ctx).premiumTestBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(ctx).confirmDiscard),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(ctx).premiumSubscribe),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final err = await ref.read(searchRepositoryProvider).activateTestPremium();
    if (!mounted) return;

    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
      return;
    }

    await _checkPremium();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).premiumActivated)),
    );
    await _loadCommunity();
  }

  // ── UI ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.searchTitle),
        actions: [
          if (_filter.hasActiveFilter)
            IconButton(
              tooltip: l.searchClear,
              icon: const Icon(Icons.filter_alt_off),
              onPressed: () {
                _controller.clear();
                _onFilterChanged(
                    () => _filter = const ObservationFilter());
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l.searchTabMine),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    (_isPremium == true)
                        ? Icons.public
                        : Icons.lock_outline,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(l.searchTabCommunity),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Kereső mező
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: (v) => _onFilterChanged(() {
                _filter = _filter.copyWith(text: v);
              }),
              decoration: InputDecoration(
                hintText: l.searchFieldHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _onFilterChanged(
                              () => _filter = _filter.copyWith(text: ''));
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Szűrő chipek
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _chip(l.searchGroupPlants, 'plant'),
                _chip(l.searchGroupAnimals, 'animal'),
                _chip(l.searchGroupInsects, 'insect'),
                _chip(l.searchGroupFungi, 'fungus'),
                const SizedBox(width: 8),
                _chipState(l.searchIdentified, true),
                _chipState(l.searchUnidentified, false),
              ],
            ),
          ),

          // Dátumtartomány
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.date_range, size: 18),
                    label: Text(
                      _filter.from == null
                          ? l.searchFromDate
                          : _fmt(_filter.from!),
                    ),
                    onPressed: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _filter.from ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (d != null) {
                        _onFilterChanged(() {
                          _filter = _filter.copyWith(from: d);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.date_range, size: 18),
                    label: Text(
                      _filter.to == null
                          ? l.searchToDate
                          : _fmt(_filter.to!),
                    ),
                    onPressed: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _filter.to ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (d != null) {
                        _onFilterChanged(() {
                          _filter = _filter.copyWith(to: d);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),

          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _mineTab(l),
                _communityTab(l),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: _filter.group == value,
        onSelected: (_) => _onFilterChanged(() {
          _filter = _filter.group == value
              ? _filter.copyWith(clearGroup: true)
              : _filter.copyWith(group: value);
        }),
      ),
    );
  }

  Widget _chipState(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: _filter.identifiedOnly == value,
        onSelected: (_) => _onFilterChanged(() {
          _filter = _filter.identifiedOnly == value
              ? _filter.copyWith(clearIdentified: true)
              : _filter.copyWith(identifiedOnly: value);
        }),
      ),
    );
  }

  // ── Saját fül ───────────────────────────────────────────────────────

  Widget _mineTab(AppLocalizations l) {
    final lang = _langCode();
    final results = _mineResults;

    if (_loadingMine) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMine != null) {
      return Center(child: Text(l.observationsError(_errorMine!)));
    }
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off, size: 48),
              const SizedBox(height: 12),
              Text(
                _mine.isEmpty ? l.observationsEmpty : l.searchNoResults,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _countRow(l.searchResultCount(results.length)),
        Expanded(
          child: ListView.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) =>
                _row(results[i], lang, l, showThumb: true),
          ),
        ),
      ],
    );
  }

  // ── Közösségi fül ───────────────────────────────────────────────────

  Widget _communityTab(AppLocalizations l) {
    if (_isPremium == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_isPremium == false) {
      return _premiumPaywall(l);
    }

    final lang = _langCode();

    return Column(
      children: [
        Expanded(
          child: _loadingCommunity
              ? const Center(child: CircularProgressIndicator())
              : _errorCommunity != null
                  ? Center(child: Text(l.observationsError(_errorCommunity!)))
                  : _community.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.public_off, size: 48),
                                const SizedBox(height: 12),
                                Text(
                                  l.searchCommunityEmpty,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                FilledButton.icon(
                                  icon: const Icon(Icons.refresh),
                                  label: Text(l.searchCommunityLoad),
                                  onPressed: _loadCommunity,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            _countRow(
                                l.searchResultCount(_community.length)),
                            Expanded(
                              child: ListView.separated(
                                itemCount: _community.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, i) => _row(
                                  _community[i],
                                  lang,
                                  l,
                                  showThumb: true,
                                ),
                              ),
                            ),
                          ],
                        ),
        ),
      ],
    );
  }

  /// A prémium díjtábla — fizetés előtti állapot.
  Widget _premiumPaywall(AppLocalizations l) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 2,
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
                    onPressed: _enableTestPremium,
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

  Widget _featureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  // ── Közös lista-elem ────────────────────────────────────────────────

  Widget _countRow(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }

  Widget _row(
    Observation o,
    String lang,
    AppLocalizations l, {
    required bool showThumb,
  }) {
    final name =
        o.hasSpecies ? o.displayNameFor(lang) : l.observationsUnknownSpecies;
    final when = o.observedAt != null
        ? o.observedAt!.toLocal().toString().substring(0, 16)
        : '';

    // A listában a miniatűrt használjuk, ha van; egyébként a nagy fotót.
    final listPath = o.listPhotoPath;
    final photoUrl = listPath != null
        ? ref.read(observationRepositoryProvider).photoUrl(listPath)
        : null;

    return ListTile(
      leading: (showThumb && photoUrl != null)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                photoUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.broken_image),
                ),
              ),
            )
          : const Icon(Icons.park),
      title: Text(name),
      subtitle: Text(
        '${o.latitude.toStringAsFixed(4)}, '
        '${o.longitude.toStringAsFixed(4)}'
        '${when.isNotEmpty ? ' · $when' : ''}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showDetail(o, lang, l),
    );
  }

  /// A megfigyelés részletnézete — alsó lap, a nagy fotóval.
  void _showDetail(Observation o, String lang, AppLocalizations l) {
    final bigPath = o.photoPath ?? o.photoThumbPath;
    final photoUrl = bigPath != null
        ? ref.read(observationRepositoryProvider).photoUrl(bigPath)
        : null;
    final name =
        o.hasSpecies ? o.displayNameFor(lang) : l.observationsUnknownSpecies;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
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

              if (photoUrl != null)
                GestureDetector(
                  onTap: () => _showFullImage(photoUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        Image.network(
                          photoUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return const SizedBox(
                              height: 220,
                              child:
                                  Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (_, __, ___) => const SizedBox(
                            height: 220,
                            child: Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.black54,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            l.tapForFullSize,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              Text(name, style: Theme.of(ctx).textTheme.titleLarge),
              if (o.scientificName != null && o.scientificName != name) ...[
                const SizedBox(height: 4),
                Text(
                  o.scientificName!,
                  style: Theme.of(ctx)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
              const SizedBox(height: 8),
              Text(l.observationsGps(
                o.latitude.toStringAsFixed(5),
                o.longitude.toStringAsFixed(5),
              )),
              if (o.observedAt != null)
                Text(l.observationsDateTime(
                    o.observedAt!.toLocal().toString())),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// A fotó teljes méretben — külön képernyőn, nagyíthatóan.
  void _showFullImage(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Image.network(url, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
