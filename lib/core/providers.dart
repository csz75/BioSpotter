import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/auth_service.dart';
import '../features/identification/col_search_service.dart';
import '../features/identification/identification_service.dart';
import '../features/identification/species_repository.dart';
import '../features/observations/observation_repository.dart';
import '../features/search/search_repository.dart';
import '../features/observations/like_repository.dart';

import '../features/groups/group_repository.dart';

import '../features/bounties/bounty_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(supabaseClientProvider)),
);

final observationRepositoryProvider = Provider<ObservationRepository>(
  (ref) => ObservationRepository(ref.watch(supabaseClientProvider)),
);

final identificationServiceProvider = Provider<IdentificationService>(
  (ref) => IdentificationService(ref.watch(supabaseClientProvider)),
);


/// A fajkereső a SAJÁT adatbázisból (~1,13 millió faj).
final speciesRepositoryProvider = Provider<SpeciesRepository>(
  (ref) => SpeciesRepository(ref.watch(supabaseClientProvider)),
);

/// A megfigyelés-keresés (saját + közösségi) és az előfizetés.
final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(ref.watch(supabaseClientProvider)),
);

/// A GBIF-alapú kereső (Edge Function). Megmarad, de a fajkereső
/// már a saját adatbázisból dolgozik.
final colSearchServiceProvider = Provider<ColSearchService>(
  (ref) => ColSearchService(ref.watch(supabaseClientProvider)),
);

final likeRepositoryProvider = Provider<LikeRepository>(
  (ref) => LikeRepository(ref.watch(supabaseClientProvider)),
);

final groupRepositoryProvider = Provider<GroupRepository>(
  (ref) => GroupRepository(ref.watch(supabaseClientProvider)),
);

final bountyRepositoryProvider = Provider<BountyRepository>(
  (ref) => BountyRepository(ref.watch(supabaseClientProvider)),
);


