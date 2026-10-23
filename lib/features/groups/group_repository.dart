import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../observations/observation.dart';

/// Egy csoport.
class Group {
  const Group({
    required this.id,
    required this.name,
    this.description,
    required this.inviteCode,
    required this.status,
    required this.isOwner,
  });

  final String id;
  final String name;
  final String? description;
  final String inviteCode;
  final String status;
  final bool isOwner;

  bool get isArchived => status == 'archived';

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      inviteCode: json['invite_code'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      isOwner: json['is_owner'] as bool? ?? false,
    );
  }
}

/// Egy csoporttag.
class GroupMember {
  const GroupMember({
    required this.userId,
    required this.displayName,
    required this.role,
  });

  final String userId;
  final String displayName;
  final String role;

  bool get isOwner => role == 'owner';
}

class GroupRepository {
  GroupRepository(this._client);

  final SupabaseClient _client;

  /// Véletlen meghívó kód (pl. "5B-4K7X").
  static String generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random();
    String block(int n) =>
        List.generate(n, (_) => chars[rnd.nextInt(chars.length)]).join();
    return '${block(4)}-${block(4)}';
  }

  /// A felhasználó AKTÍV csoportjai.
  ///
  /// A `groups!inner` belső join + a `groups.status` szűrő kell ahhoz,
  /// hogy az ARCHIVÁLT csoport ne jelenjen meg. A sima beágyazott
  /// `groups(...)` külső join lenne, és nem szűrne.
  Future<List<Group>> myGroups() async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];

    final res = await _client
        .from('group_members')
        .select(
          'group_id, role, '
          'groups!inner(id, name, description, invite_code, status, created_by)',
        )
        .eq('user_id', user.id)
        .eq('status', 'active')
        .eq('groups.status', 'active');

    return _toGroups(res, user.id);
  }

  /// A felhasználó ARCHIVÁLT csoportjai — csak az owner látja,
  /// hogy vissza tudja állítani.
  Future<List<Group>> myArchivedGroups() async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];

    final res = await _client
        .from('group_members')
        .select(
          'group_id, role, '
          'groups!inner(id, name, description, invite_code, status, created_by)',
        )
        .eq('user_id', user.id)
        .eq('role', 'owner')
        .eq('groups.status', 'archived');

    return _toGroups(res, user.id);
  }

  List<Group> _toGroups(dynamic res, String userId) {
    final rows = (res as List).cast<Map<String, dynamic>>();
    return rows.map((r) {
      final g = (r['groups'] as Map?) ?? const {};
      return Group(
        id: g['id'] as String,
        name: g['name'] as String,
        description: g['description'] as String?,
        inviteCode: g['invite_code'] as String? ?? '',
        status: g['status'] as String? ?? 'active',
        isOwner: g['created_by'] == userId,
      );
    }).toList();
  }

  /// Csoport létrehozása.
  Future<Group> createGroup({
    required String name,
    String? description,
  }) async {
    final code = generateInviteCode();
    final id = await _client.rpc('create_group', params: {
      'p_name': name,
      'p_description': description,
      'p_invite_code': code,
    });
    return Group(
      id: id as String,
      name: name,
      description: description,
      inviteCode: code,
      status: 'active',
      isOwner: true,
    );
  }

  /// Csatlakozás meghívó kóddal.
  Future<void> joinGroup(String inviteCode) async {
    await _client.rpc('join_group', params: {'p_invite_code': inviteCode});
  }

  /// Egy csoport aktív tagjai.
  Future<List<GroupMember>> members(String groupId) async {
    final res = await _client
        .from('group_members')
        .select(
          'user_id, role, status, joined_at, '
          'users(display_name, email)',
        )
        .eq('group_id', groupId)
        .eq('status', 'active')
        .order('joined_at');

    final rows = (res as List).cast<Map<String, dynamic>>();
    return rows.map((r) {
      final u = (r['users'] as Map?) ?? const {};
      return GroupMember(
        userId: r['user_id'] as String,
        displayName: (u['display_name'] as String?) ?? '—',
        role: (r['role'] as String?) ?? 'member',
      );
    }).toList();
  }

  /// Kilépés a csoportból.
  ///
  /// A megfigyelések megmaradnak a csoportban (a `group_id` a megfigyelésen
  /// van, nem a tagságon) — csak a hozzáférés szűnik meg.
  Future<void> leaveGroup(String groupId) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Nincs bejelentkezett felhasználó');

    await _client
        .from('group_members')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', user.id);
  }

  /// A csoport archiválása — csak az owner.
  Future<void> archiveGroup(String groupId) async {
    await _client
        .from('groups')
        .update({'status': 'archived'})
        .eq('id', groupId);
  }

  /// Archivált csoport visszaállítása — csak az owner.
  Future<void> restoreGroup(String groupId) async {
    await _client
        .from('groups')
        .update({'status': 'active'})
        .eq('id', groupId);
  }

  /// Tag eltávolítása — csak az owner.
  Future<void> removeMember(String groupId, String userId) async {
    await _client
        .from('group_members')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', userId);
  }

  /// Egy csoport megfigyelései.
  Future<List<Observation>> groupObservations(String groupId) async {
    final res = await _client.rpc('group_observations', params: {
      'p_group_id': groupId,
      'p_limit': 200,
    });
    return (res as List)
        .map((e) => _observationFromRpc(e as Map<String, dynamic>))
        .toList();
  }

  Observation _observationFromRpc(Map<String, dynamic> row) {
    final vernacular = <String, String>{};
    final raw = row['vernacular_names'];
    if (raw is Map) {
      raw.forEach((k, v) {
        if (v is String && v.isNotEmpty) vernacular[k.toString()] = v;
      });
    }
    final observedRaw = row['observed_at'];
    DateTime? observedAt;
    if (observedRaw is String) observedAt = DateTime.tryParse(observedRaw);

    return Observation(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      latitude: ((row['latitude'] ?? 0) as num).toDouble(),
      longitude: ((row['longitude'] ?? 0) as num).toDouble(),
      speciesId: row['species_id'] as String?,
      scientificName: row['scientific_name'] as String?,
      commonNameHu: row['common_name_hu'] as String?,
      vernacularNames: vernacular,
      iconicTaxon: row['iconic_taxon'] as String?,
      observedAt: observedAt,
      photoPath: row['photo_path'] as String?,
      photoThumbPath: row['thumb_path'] as String?,
      moderationStatus: row['moderation_status'] as String? ?? 'published',
    );
  }
}
