/// Egy fajjavaslat az azonosítóból.
class SpeciesSuggestion {
  const SpeciesSuggestion({
    this.taxonId,
    this.scientificName,
    this.commonName,
    this.rank,
    this.iconicTaxon,
    required this.score,
    this.vernacularNames,
    this.gbifKey,
  });

  final int? taxonId;
  final String? scientificName;
  final String? commonName;
  final String? rank;
  final String? iconicTaxon;
  final double score; // 0-100

  /// Nyelvenkénti népies nevek (GBIF-kód kulccsal), ha ismertek.
  final Map<String, String>? vernacularNames;

  /// A GBIF azonosító, ha a találat onnan jött.
  final int? gbifKey;

  /// A megjelenített név: vesszős név, ha van, egyébként a tudományos.
  String get displayName => commonName ?? scientificName ?? '?';

  /// Az azonosítás erőssége szövegesen.
  String get confidenceLabel {
    if (score >= 85) return 'magas';
    if (score >= 60) return 'közepes';
    return 'bizonytalan';
  }

  factory SpeciesSuggestion.fromJson(Map<String, dynamic> json) {
    final raw = json['vernacular_names'];
    final map = <String, String>{};
    if (raw is Map) {
      raw.forEach((k, v) {
        if (v is String && v.isNotEmpty) map[k.toString()] = v;
      });
    }

    return SpeciesSuggestion(
      taxonId: json['taxon_id'] as int?,
      scientificName: json['scientific_name'] as String?,
      commonName: json['common_name'] as String?,
      rank: json['rank'] as String?,
      iconicTaxon: json['iconic_taxon'] as String?,
      score: ((json['score'] ?? 0) as num).toDouble(),
      vernacularNames: map.isEmpty ? null : map,
      gbifKey: json['gbif_key'] as int?,
    );
  }
}
