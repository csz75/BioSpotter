import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_controller.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import 'bounties_screen.dart';
import 'camera_screen.dart';
import 'groups_screen.dart';
import 'login_screen.dart';
import 'map_screen.dart';
import 'observation_list_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(supabaseClientProvider);
    final email = client.auth.currentUser?.email ?? '';
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l.settingsTitle,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l.homeGreeting(email),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 32),
              FilledButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: Text(l.homeNewObservation),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CameraScreen()),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.list),
                label: Text(l.homeMyObservations),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ObservationListScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.map),
                label: Text(l.homeMap),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MapScreen()),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.search),
                label: Text(l.searchTitle),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.groups_outlined),
                label: Text(l.groupsTitle),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GroupsScreen()),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.track_changes),
                label: Text(l.bountyTitle),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BountiesScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
