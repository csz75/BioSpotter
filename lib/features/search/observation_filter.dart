import '../observations/observation.dart';
import 'package:flutter/foundation.dart';


/// A megfigyelés-keresés szűrőfeltételei.
/// Később a közösségi (prémium) nézet ugyanezt a modellt használja,
/// csak több mezővel (pl. körzet, felhasználó).
class ObservationFilter {
  const ObservationFilter({
    this.text = '',
    this.group,          // 'plant' | 'animal' | 'fungus' | 'insect' | null
    this.identifiedOnly, // null = mindegy, true = csak azonosított, false = csak azonosítatlan
    this.from,
    this.to,
  });

  /// Szabad szöveges keresés — a faj nevére (bármelyik nyelven).
  final String text;

  /// Fajcsoport szűrő.
  final String? group;

  /// Azonosított / azonosítatlan szűrő.
  final bool? identifiedOnly;

  /// Dátumtartomány.
  final DateTime? from;
  final DateTime? to;

  bool get isEmpty =>
      text.trim().isEmpty &&
      group == null &&
      identifiedOnly == null &&
      from == null &&
      to == null;

  bool get hasActiveFilter => !isEmpty;

  ObservationFilter copyWith({
    String? text,
    String? group,
    bool? identifiedOnly,
    DateTime? from,
    DateTime? to,
    bool clearGroup = false,
    bool clearIdentified = false,
    bool clearFrom = false,
    bool clearTo = false,
  }) {
    return ObservationFilter(
      text: text ?? this.text,
      group: clearGroup ? null : (group ?? this.group),
      identifiedOnly:
          clearIdentified ? null : (identifiedOnly ?? this.identifiedOnly),
      from: clearFrom ? null : (from ?? this.from),
      to: clearTo ? null : (to ?? this.to),
    );
  }

  /// A megfigyelés megfelel-e a szűrőnek.
  /// [searchNames] a megfigyelés összes ismert neve (bármely nyelven) —
  /// így a keresés nyelvfüggetlen.
  bool matches(Observation o, {required List<String> searchNames}) {
    // 1. Szöveges keresés
    final q = text.trim().toLowerCase();
    if (q.isNotEmpty) {
      final hit = searchNames.any((n) => n.toLowerCase().contains(q));
      if (!hit) return false;
    }

    // 2. Fajcsoport
    if (group != null) {
      final g = _groupOf(o);
      if (g != group) return false;
    }

    // 3. Azonosítottság
    if (identifiedOnly != null) {
      if (identifiedOnly! && !o.hasSpecies) return false;
      if (!identifiedOnly! && o.hasSpecies) return false;
    }

    // 4. Dátumtartomány
    final at = o.observedAt?.toLocal();
    if (from != null && at != null && at.isBefore(from!)) return false;
    if (to != null && at != null && at.isAfter(to!)) return false;

    return true;
  }

  /// A megfigyelés fajcsoportja a `taxonomy_json.iconic_taxon` alapján.
  static String? _groupOf(Observation o) {
    final raw = o.iconicTaxon?.toLowerCase();
    debugPrint('groupOf: iconicTaxon = ${o.iconicTaxon} → raw = $raw');
    if (raw == null) return null;
    if (raw.contains('plant')) return 'plant';
    if (raw.contains('fung')) return 'fungus';
    if (raw.contains('insect')) return 'insect';
    if (raw.contains('animal') ||
        raw.contains('aves') ||
        raw.contains('mammal') ||
        raw.contains('amphib') ||
        raw.contains('reptil') ||
        raw.contains('fish') ||
        raw.contains('arachnid') ||
        raw.contains('mollusc')) {
      return 'animal';
    }
    return null;
  }
}
