/// ISO 639-1 (app nyelv) → ISO 639-3 (GBIF/COL nyelvkód) átváltó.
/// A `vernacular_names` szótár GBIF-kódokkal kulcsolt, a UI viszont
/// rövid kódokat használ.
const Map<String, String> _iso1ToIso3 = {
  'hu': 'hun',
  'en': 'eng',
  'de': 'deu',
  'fr': 'fra',
  'es': 'spa',
  'it': 'ita',
  'pl': 'pol',
};

class Observation {
  const Observation({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.speciesId,
    this.scientificName,
    this.commonNameHu,
    this.vernacularNames = const {},
    this.iconicTaxon,
    this.observedAt,
    this.photoPath,
    this.photoThumbPath,
  });

  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final String? speciesId;
  final String? scientificName;
  final String? commonNameHu;

  /// Nyelvenkénti népies nevek (GBIF-kód kulccsal):
  /// {"hun": "...", "eng": "...", "deu": "...", ...}
  final Map<String, String> vernacularNames;

  /// A faj fő csoportja (pl. "Plantae", "Animalia", "Insecta", "Fungi") —
  /// a `species.taxonomy_json.iconic_taxon` mezőből.
  final String? iconicTaxon;

  final DateTime? observedAt;

  /// A nagy fotó útvonala a Storage-ban (a részletnézethez).
  final String? photoPath;

  /// A lista miniatűrje a Storage-ban (ha van) — a listához.
  /// Ha nincs külön thumbnail, a [photoPath]-ot használjuk.
  final String? photoThumbPath;

  /// A listában használandó kép útvonala: thumbnail, ha van; egyébként a nagy fotó.
  String? get listPhotoPath => photoThumbPath ?? photoPath;

  /// A fajnév az adott app-nyelven (ISO 639-1 kód, pl. "hu").
  /// Visszaesés: magyar név → tudományos név.
  String displayNameFor(String appLangCode) {
    final colLang = _iso1ToIso3[appLangCode] ?? 'eng';
    final localized = vernacularNames[colLang];
    if (localized != null && localized.isNotEmpty) return localized;
    if (commonNameHu != null && commonNameHu!.isNotEmpty) return commonNameHu!;
    return scientificName ?? '?';
  }

  /// Van-e egyáltalán neve a fajnak.
  bool get hasSpecies =>
      speciesId != null ||
      (scientificName != null && scientificName!.isNotEmpty);

  factory Observation.fromJson(Map<String, dynamic> json) {
    // A koordináták: elsődlegesen a nézet adja, visszaesés a GeoJSON
    double lat = 0;
    double lng = 0;
    if (json['latitude'] != null && json['longitude'] != null) {
      lat = (json['latitude'] as num).toDouble();
      lng = (json['longitude'] as num).toDouble();
    } else {
      final location = json['location'];
      if (location is Map && location['coordinates'] is List) {
        final coords = location['coordinates'] as List;
        lng = (coords[0] as num).toDouble();
        lat = (coords[1] as num).toDouble();
      }
    }

    final species = json['species'];
    String? scientificName;
    String? commonNameHu;
    String? iconicTaxon;
    final vernacular = <String, String>{};

    if (species is Map) {
      scientificName = species['scientific_name'] as String?;
      commonNameHu = species['common_name_hu'] as String?;

      final raw = species['vernacular_names'];
      if (raw is Map) {
        raw.forEach((k, v) {
          if (v is String && v.isNotEmpty) vernacular[k.toString()] = v;
        });
      }

      final tax = species['taxonomy_json'];
      if (tax is Map) {
        final icon = tax['iconic_taxon'];
        if (icon is String && icon.isNotEmpty) iconicTaxon = icon;
      }
    }

    String? photoPath;
    String? photoThumbPath;
    final photos = json['photos'];
    if (photos is List && photos.isNotEmpty) {
      final first = photos.first as Map;
      photoPath = first['storage_path'] as String?;
      photoThumbPath = first['thumbnail_path'] as String?;
    }

    return Observation(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      latitude: lat,
      longitude: lng,
      speciesId: json['species_id'] as String?,
      scientificName: scientificName,
      commonNameHu: commonNameHu,
      vernacularNames: vernacular,
      iconicTaxon: iconicTaxon,
      observedAt: json['observed_at'] != null
          ? DateTime.parse(json['observed_at'] as String)
          : null,
      photoPath: photoPath,
      photoThumbPath: photoThumbPath,
    );
  }
}
