import 'legal_hu.dart';
import 'legal_en.dart';
import 'legal_de.dart';
import 'legal_fr.dart';
import 'legal_es.dart';
import 'legal_it.dart';
import 'legal_pl.dart';

/// A jogi dokumentum fajtái.
enum LegalDoc { privacy, terms, deletion }

/// Egy jogi dokumentum: szakaszok listája, mindegyik (cím, bekezdések).
typedef LegalBlocks = List<(String, List<String>)>;

/// Egy nyelv teljes jogi szövegkészlete.
class LegalTexts {
  const LegalTexts({
    required this.privacy,
    required this.terms,
    required this.deletion,
  });

  final LegalBlocks privacy;
  final LegalBlocks terms;
  final LegalBlocks deletion;
}

/// A kért nyelv szövegkészlete. Ismeretlen nyelvre a magyar.
LegalTexts legalTextsFor(String lang) {
  switch (lang) {
    case 'en':
      return legalTextsEn;
    case 'de':
      return legalTextsDe;
    case 'fr':
      return legalTextsFr;
    case 'es':
      return legalTextsEs;
    case 'it':
      return legalTextsIt;
    case 'pl':
      return legalTextsPl;
    default:
      return legalTextsHu;
  }
}

/// A kért dokumentum blokkjai az adott nyelven.
LegalBlocks legalBlocks(LegalDoc doc, String lang) {
  final t = legalTextsFor(lang);
  switch (doc) {
    case LegalDoc.privacy:
      return t.privacy;
    case LegalDoc.terms:
      return t.terms;
    case LegalDoc.deletion:
      return t.deletion;
  }
}
