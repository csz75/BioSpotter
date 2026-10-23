/// Egy fajkeresési találat a SAJÁT adatbázisból (species tábla).
class ColMatch {
  const ColMatch({
    this.id,
    this.gbifKey,
    this.scientificName,
    this.authorship,
    this.rank,
    this.status,
    this.kingdom,
    this.family,
    this.genus,
    this.commonName,
    this.commonNameLang,
    this.vernacularNames = const {},
  });

  /// A saját `species.id` (uuid) — a kitűzéshez és az illeszkedéshez.
  final String? id;

  /// A GBIF / iNaturalist taxon-szám (ha van).
  final int? gbifKey;

  final String? scientificName;
  final String? authorship;
  final String? rank;
  final String? status;
  final String? kingdom;
  final String? family;
  final String? genus;
  final String? commonName;
  final String? commonNameLang;

  /// Nyelvenkénti népies nevek: {"hun": "...", "eng": "..."}
  final Map<String, String> vernacularNames;

  /// A megjelenített név a kért nyelven, vagy a tudományos név.
  String displayNameFor(String lang) {
    return vernacularNames[lang] ?? commonName ?? scientificName ?? '?';
  }

  factory ColMatch.fromJson(Map<String, dynamic> json) {
    final raw = json['vernacular_names'];
    final map = <String, String>{};
    if (raw is Map) {
      raw.forEach((k, v) {
        if (v is String && v.isNotEmpty) map[k.toString()] = v;
      });
    }

    // A `col_id` az iNaturalist/GBIF szám — int-be, ha lehet.
    final colId = json['col_id'];
    final gbif = colId is String ? int.tryParse(colId) : (colId as int?);

    return ColMatch(
      id: json['id'] as String?,
      gbifKey: json['gbif_key'] as int? ?? gbif,
      scientificName: json['scientific_name'] as String?,
      authorship: json['authorship'] as String?,
      rank: json['rank'] as String?,
      status: json['status'] as String?,
      kingdom: json['kingdom'] as String?,
      family: json['family'] as String?,
      genus: json['genus'] as String?,
      commonName: json['common_name'] as String?,
      commonNameLang: json['common_name_lang'] as String?,
      vernacularNames: map,
    );
  }
}
