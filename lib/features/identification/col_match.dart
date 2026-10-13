/// Egy fajkeresési találat a GBIF-ből.
class ColMatch {
  const ColMatch({
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

    return ColMatch(
      gbifKey: json['gbif_key'] as int?,
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
