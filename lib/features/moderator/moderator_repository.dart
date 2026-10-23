import 'package:supabase_flutter/supabase_flutter.dart';

/// Egy jóváhagyásra váró kitűzés.
class PendingBounty {
  const PendingBounty({
    required this.id,
    required this.title,
    this.description,
    this.creatorEmail,
    required this.rewardPoints,
    required this.maxWinners,
  });

  final String id;
  final String title;
  final String? description;
  final String? creatorEmail;
  final int rewardPoints;
  final int maxWinners;

  factory PendingBounty.fromJson(Map<String, dynamic> json) {
    return PendingBounty(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      creatorEmail: json['creator_email'] as String?,
      rewardPoints: (json['reward_points'] as num?)?.toInt() ?? 0,
      maxWinners: (json['max_winners'] as num?)?.toInt() ?? 3,
    );
  }
}

/// Egy bejelentett (flagged) megfigyelés.
class FlaggedObservation {
  const FlaggedObservation({
    required this.id,
    this.scientificName,
    this.commonNameHu,
    this.photoPath,
    this.thumbPath,
    required this.latitude,
    required this.longitude,
    this.observedAt,
    this.flaggedAt,
    required this.reportCount,
    required this.reasons,
  });

  final String id;
  final String? scientificName;
  final String? commonNameHu;
  final String? photoPath;
  final String? thumbPath;
  final double latitude;
  final double longitude;
  final DateTime? observedAt;
  final DateTime? flaggedAt;
  final int reportCount;
  final String reasons;

  factory FlaggedObservation.fromJson(Map<String, dynamic> json) {
    return FlaggedObservation(
      id: json['id'] as String,
      scientificName: json['scientific_name'] as String?,
      commonNameHu: json['common_name_hu'] as String?,
      photoPath: json['photo_path'] as String?,
      thumbPath: json['thumb_path'] as String?,
      latitude: ((json['latitude'] ?? 0) as num).toDouble(),
      longitude: ((json['longitude'] ?? 0) as num).toDouble(),
      observedAt: json['observed_at'] != null
          ? DateTime.tryParse(json['observed_at'] as String)
          : null,
      flaggedAt: json['flagged_at'] != null
          ? DateTime.tryParse(json['flagged_at'] as String)
          : null,
      reportCount: (json['report_count'] as num?)?.toInt() ?? 0,
      reasons: json['reasons'] as String? ?? '',
    );
  }
}

class ModeratorRepository {
  ModeratorRepository(this._client);

  final SupabaseClient _client;

  /// Moderátor-e a bejelentkezett felhasználó.
  Future<bool> isModerator() async {
    final user = _client.auth.currentUser;
    if (user == null) return false;
    try {
      final res = await _client.rpc('is_moderator');
      return res == true;
    } catch (_) {
      return false;
    }
  }

  /// A jóváhagyásra váró kitűzések.
  Future<List<PendingBounty>> pendingBounties() async {
    try {
      final res = await _client.rpc('pending_bounties');
      return (res as List)
          .map((e) => PendingBounty.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  /// A bejelentett megfigyelések.
  Future<List<FlaggedObservation>> flaggedObservations() async {
    try {
      final res = await _client.rpc('flagged_observations');
      return (res as List)
          .map((e) => FlaggedObservation.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  /// Kitűzés jóváhagyása.
  Future<String?> approveBounty(String bountyId) async {
    try {
      await _client.rpc('approve_bounty', params: {'p_bounty_id': bountyId});
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  /// Kitűzés elutasítása (moderátor) — 'cancelled' státusz.
  Future<String?> moderateBountyReject(String bountyId) async {
    try {
      await _client
          .from('bounties')
          .update({'status': 'cancelled'})
          .eq('id', bountyId);
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  /// Megfigyelés moderálása: 'publish' | 'reject' | 'pending'.
  Future<String?> moderateObservation({
    required String observationId,
    required String action,
    String? note,
  }) async {
    try {
      await _client.rpc('moderate_observation', params: {
        'p_observation_id': observationId,
        'p_action': action,
        'p_note': note,
      });
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  /// A Storage-ban tárolt kép URL-je.
  String photoUrl(String storagePath) {
    return _client.storage.from('photos').getPublicUrl(storagePath);
  }
}
