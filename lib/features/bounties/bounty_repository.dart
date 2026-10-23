import 'package:supabase_flutter/supabase_flutter.dart';

/// Egy kitűzés (bounty).
class Bounty {
  const Bounty({
    required this.id,
    required this.creatorId,
    required this.title,
    this.description,
    this.speciesId,
    this.scientificName,
    this.commonNameHu,
    required this.rewardPoints,
    required this.maxWinners,
    required this.status,
    this.expiresAt,
    this.createdAt,
    this.acceptedCount = 0,
    this.isMine = false,
  });

  final String id;
  final String creatorId;
  final String title;
  final String? description;
  final String? speciesId;
  final String? scientificName;
  final String? commonNameHu;
  final int rewardPoints;
  final int maxWinners;
  final String status; // pending_approval | open | claimed | paid | cancelled
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final int acceptedCount;
  final bool isMine;

  bool get isOpen => status == 'open';
  bool get isPendingApproval => status == 'pending_approval';
  bool get isPaid => status == 'paid';
  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());

  /// A hátralévő helyek száma.
  int get slotsLeft => (maxWinners - acceptedCount).clamp(0, maxWinners);

  factory Bounty.fromJson(Map<String, dynamic> json, {String? myUserId}) {
    final sp = json['species'];

    // Az elfogadott beküldések száma — a beágyazott `bounty_claims`-ből.
    int accepted = 0;
    final claims = json['bounty_claims'];
    if (claims is List) {
      accepted = claims.length;
    } else if (json['accepted_count'] != null) {
      accepted = (json['accepted_count'] as num?)?.toInt() ?? 0;
    }

    return Bounty(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      speciesId: json['species_id'] as String?,
      scientificName: sp is Map ? sp['scientific_name'] as String? : null,
      commonNameHu: sp is Map ? sp['common_name_hu'] as String? : null,
      rewardPoints: (json['reward_points'] as num?)?.toInt() ?? 0,
      maxWinners: (json['max_winners'] as num?)?.toInt() ?? 3,
      status: json['status'] as String? ?? 'open',
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      acceptedCount: accepted,
      isMine: myUserId != null && json['creator_id'] == myUserId,
    );
  }
}

/// Egy beküldés.
class BountyClaim {
  const BountyClaim({
    required this.id,
    required this.bountyId,
    required this.claimerId,
    required this.observationId,
    required this.status,
    this.reviewerNote,
    this.photoPath,
    this.scientificName,
  });

  final String id;
  final String bountyId;
  final String claimerId;
  final String observationId;
  final String status; // pending | accepted | rejected
  final String? reviewerNote;
  final String? photoPath;
  final String? scientificName;

  bool get isAccepted => status == 'accepted';
  bool get isPending => status == 'pending';

  factory BountyClaim.fromJson(Map<String, dynamic> json) {
    final obs = json['observations'];
    String? photoPath;
    if (obs is Map) {
      final photos = obs['photos'];
      if (photos is List && photos.isNotEmpty) {
        photoPath = (photos.first as Map)['storage_path'] as String?;
      }
    }
    final sp = obs is Map ? obs['species'] : null;
    return BountyClaim(
      id: json['id'] as String,
      bountyId: json['bounty_id'] as String,
      claimerId: json['claimer_id'] as String,
      observationId: json['observation_id'] as String,
      status: json['status'] as String? ?? 'pending',
      reviewerNote: json['reviewer_note'] as String?,
      photoPath: photoPath,
      scientificName: sp is Map ? sp['scientific_name'] as String? : null,
    );
  }
}

class BountyRepository {
  BountyRepository(this._client);

  final SupabaseClient _client;

  /// Az összes NYITOTT kitűzés (a jóváhagyottak).
  Future<List<Bounty>> openBounties() async {
    final user = _client.auth.currentUser;
    final res = await _client
        .from('bounties')
        .select(
          'id, creator_id, title, description, species_id, '
          'reward_points, max_winners, status, expires_at, created_at, '
          'species(scientific_name, common_name_hu), '
          'bounty_claims(id, status)',
        )
        .eq('status', 'open')
        .order('expires_at', ascending: true, nullsFirst: false);

    return (res as List)
        .map((e) => Bounty.fromJson(
              e as Map<String, dynamic>,
              myUserId: user?.id,
            ))
        .toList();
  }

  /// A saját kitűzéseim (bármilyen státuszban).
  Future<List<Bounty>> myBounties() async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];

    final res = await _client
        .from('bounties')
        .select(
          'id, creator_id, title, description, species_id, '
          'reward_points, max_winners, status, expires_at, created_at, '
          'species(scientific_name, common_name_hu), '
          'bounty_claims(id, status)',
        )
        .eq('creator_id', user.id)
        .order('created_at', ascending: false);

    return (res as List)
        .map((e) => Bounty.fromJson(
              e as Map<String, dynamic>,
              myUserId: user.id,
            ))
        .toList();
  }

  /// Kitűzés létrehozása. Terület nélkül (az „A" modell).
  /// Visszatérés: null = siker, egyébként a hibaüzenet.
  Future<String?> createBounty({
    required String title,
    String? description,
    String? speciesId,
    required int rewardPoints,
    required int maxWinners,
    DateTime? expiresAt,
  }) async {
    try {
      await _client.rpc('create_bounty', params: {
        'p_title': title,
        'p_description': description,
        'p_species_id': speciesId,
        'p_reward_points': rewardPoints,
        'p_region': null,
        'p_radius_km': null,
        'p_expires_at': expiresAt?.toUtc().toIso8601String(),
        'p_max_winners': maxWinners,
        'p_group_id': null,
      });
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  /// Megfigyelés beküldése egy kitűzésre.
  /// Visszatérés: null = siker, egyébként a hibaüzenet.
  Future<String?> claimBounty({
    required String bountyId,
    required String observationId,
  }) async {
    try {
      await _client.rpc('claim_bounty', params: {
        'p_bounty_id': bountyId,
        'p_observation_id': observationId,
      });
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  /// Egy kitűzés beküldései (a kitűzőnek vagy moderátornak).
  Future<List<BountyClaim>> claims(String bountyId) async {
    final res = await _client
        .from('bounty_claims')
        .select(
          'id, bounty_id, claimer_id, observation_id, status, reviewer_note, '
          'observations(photos(storage_path), species(scientific_name))',
        )
        .eq('bounty_id', bountyId)
        .order('created_at');

    return (res as List)
        .map((e) => BountyClaim.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// A saját beküldéseim adott kitűzésre.
  Future<List<BountyClaim>> myClaims(String bountyId) async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];

    final res = await _client
        .from('bounty_claims')
        .select(
          'id, bounty_id, claimer_id, observation_id, status, reviewer_note, '
          'observations(photos(storage_path), species(scientific_name))',
        )
        .eq('bounty_id', bountyId)
        .eq('claimer_id', user.id);

    return (res as List)
        .map((e) => BountyClaim.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Elbírálás — elfogadásnál a pont jóváíródik.
  /// Visszatérés: null = siker, egyébként a hibaüzenet.
  Future<String?> reviewClaim({
    required String claimId,
    required bool accept,
    String? note,
  }) async {
    try {
      await _client.rpc('review_claim', params: {
        'p_claim_id': claimId,
        'p_accept': accept,
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
