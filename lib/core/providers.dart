import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/auth_service.dart';
import '../features/identification/identification_service.dart';
import '../features/observations/observation_repository.dart';
import '../features/identification/col_search_service.dart';


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

final colSearchServiceProvider = Provider<ColSearchService>(
  (ref) => ColSearchService(ref.watch(supabaseClientProvider)),
);
