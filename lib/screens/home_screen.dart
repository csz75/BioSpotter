import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../features/observations/observation.dart';
import '../l10n/app_localizations.dart';
import 'bounties_screen.dart';
import 'camera_screen.dart';
import 'groups_screen.dart';
import 'login_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<Observation>> _future;
  String? _displayName;

  @override
  void initState() {
    super.initState();
    _future = ref.read(observationRepositoryProvider).fetchMine();
    _loadName();
  }

  Future<void> _loadName() async {
    final name =
        await ref.read(observationRepositoryProvider).fetchDisplayName();
    if (mounted) setState(() => _displayName = name);
  }

  Future<void> _reload() async {
    final fresh = ref.read(observationRepositoryProvider).fetchMine();
    setState(() => _future = fresh);
    _loadName();
    try {
      await fresh;
    } catch (_) {}
  }

  String _langCode() {
    return localeController.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final client = ref.watch(supabaseClientProvider);
    final email = client.auth.currentUser?.email ?? '';

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<Observation>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                children: const [
                  SizedBox(height: 120),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }
            final items = snapshot.data ?? [];
            return _buildContent(context, l, email, items);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l,
    String email,
    List<Observation> items,
  ) {
    final lang = _langCode();
    final identified = items
        .where((o) => o.hasSpecies)
        .map((o) => o.scientificName)
        .toSet()
        .length;
    final recent = items.take(2).toList();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
      children: [
        // ── Fejléc (nincs külön AppBar, a MainShell héjában vagyunk) ──
        Row(
          children: [
            Expanded(
              child: Text(
                l.appTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: l.homeLogout,
              onPressed: () async {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Üdvözlés ──────────────────────────────────────────────
        Text(
          l.homeGreeting(
            _displayName ?? email.split('@').first,
          ),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          l.homeSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),

        // ── Nagy "Új megfigyelés" kártya ──────────────────────────
        _NewObservationCard(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CameraScreen()),
          ),
        ),
        const SizedBox(height: 20),

        // ── Statisztika ───────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _StatCard(
                count: items.length,
                label: l.homeObservationsLabel,
                icon: Icons.photo_camera_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                count: identified,
                label: l.homeSpeciesLabel,
                icon: Icons.eco_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Csoportok / Kitűzések ─────────────────────────────────
        _SectionCard(
          icon: Icons.groups_outlined,
          title: l.homeGroups,
          subtitle: l.homeGroupsHint,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const GroupsScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          icon: Icons.emoji_events_outlined,
          title: l.homeBounties,
          subtitle: l.homeBountiesHint,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const BountiesScreen()),
          ),
        ),
        const SizedBox(height: 24),

        // ── Legutóbbi megfigyelések (max. 2) ──────────────────────
        if (recent.isNotEmpty) ...[
          Text(l.homeRecent, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...recent.map(
            (o) => _RecentTile(
              observation: o,
              lang: lang,
              photoUrl: o.photoPath != null
                  ? ref
                      .read(observationRepositoryProvider)
                      .photoUrl(o.photoPath!)
                  : null,
            ),
          ),
        ],
      ],
    );
  }
}

class _NewObservationCard extends StatelessWidget {
  const _NewObservationCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Material(
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [scheme.primary, scheme.secondary],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.homeNewObservation,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.homeNewObservationHint,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.count,
    required this.label,
    required this.icon,
  });

  final int count;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: scheme.primary, size: 22),
            const SizedBox(height: 12),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Egy szekció-kártya (Csoportok / Kitűzések) a kezdőképernyőn.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: scheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  const _RecentTile({
    required this.observation,
    required this.lang,
    this.photoUrl,
  });

  final Observation observation;
  final String lang;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final name = observation.hasSpecies
        ? observation.displayNameFor(lang)
        : l.observationsUnknownSpecies;
    final when = observation.observedAt != null
        ? observation.observedAt!.toLocal().toString().substring(0, 16)
        : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: photoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  photoUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.broken_image),
                  ),
                ),
              )
            : const Icon(Icons.park),
        title: Text(name),
        subtitle: Text(when),
      ),
    );
  }
}
