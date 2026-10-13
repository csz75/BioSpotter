// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'BioSpotter';

  @override
  String get loginTitle => 'BioSpotter';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Jelszó';

  @override
  String get loginDisplayName => 'Megjelenített név';

  @override
  String get loginSignIn => 'Bejelentkezés';

  @override
  String get loginSignUp => 'Regisztráció';

  @override
  String get loginSwitchToSignUp => 'Nincs fiókod? Regisztrálj';

  @override
  String get loginSwitchToSignIn => 'Van már fiókod? Jelentkezz be';

  @override
  String get loginEmailRequired => 'Add meg az email címedet';

  @override
  String get loginEmailInvalid => 'Érvénytelen email cím';

  @override
  String get loginPasswordTooShort => 'A jelszó legalább 6 karakter';

  @override
  String loginError(String error) {
    return 'Hiba történt: $error';
  }

  @override
  String homeGreeting(String email) {
    return 'Üdv, $email!';
  }

  @override
  String get homeNewObservation => 'Új megfigyelés';

  @override
  String get homeMyObservations => 'Megfigyeléseim';

  @override
  String get homeMap => 'Térkép';

  @override
  String get homeLogout => 'Kijelentkezés';

  @override
  String get cameraTitle => 'Új megfigyelés';

  @override
  String get cameraNoCamera => 'Nem található kamera az eszközön.';

  @override
  String cameraInitFailed(String error) {
    return 'A kamera nem indult el: $error';
  }

  @override
  String get cameraRetry => 'Újrapróbálkozás';

  @override
  String get cameraSaved => 'Megfigyelés elmentve!';

  @override
  String cameraError(String error) {
    return 'Hiba: $error';
  }

  @override
  String get locationServiceDisabled =>
      'A helymeghatározás ki van kapcsolva. Kapcsold be: Beállítások → Adatvédelem → Helymeghatározás.';

  @override
  String get locationPermissionDenied =>
      'A helymeghatározás engedélyt megtagadtad.';

  @override
  String get locationPermissionDeniedForever =>
      'A helymeghatározás véglegesen tiltva. Beállítások → BioSpotter → Helymeghatározás.';

  @override
  String get locationUnavailable =>
      'Nem sikerült helyzetet meghatározni. Menj ki a szabadba, vagy várj pár másodpercet, majd próbáld újra.';

  @override
  String get observationsTitle => 'Megfigyeléseim';

  @override
  String get observationsEmpty => 'Még nincs megfigyelésed';

  @override
  String get observationsUnknownSpecies => 'Azonosítatlan faj';

  @override
  String observationsError(String error) {
    return 'Hiba: $error';
  }

  @override
  String observationsGps(String lat, String lng) {
    return 'GPS: $lat, $lng';
  }

  @override
  String observationsDateTime(String date) {
    return 'Időpont: $date';
  }

  @override
  String get searchTitle => 'Faj keresése';

  @override
  String get searchHint => 'Írd be a faj nevét...';

  @override
  String get searchStartHint =>
      'Kezdj el gépelni a faj nevének kereséséhez.\nTudományos vagy népies nevet is beírhatsz.';

  @override
  String get searchNoResults => 'Nincs találat';

  @override
  String get searchTryOtherLanguage =>
      'Próbáld másik nyelven, vagy add meg a tudományos nevet.';

  @override
  String get searchLanguage => 'Nyelv:';

  @override
  String get obsSetSpecies => 'Faj megadása / módosítása';

  @override
  String get obsReidentify => 'Újra-azonosítás';

  @override
  String get obsDelete => 'Megfigyelés törlése';

  @override
  String get obsDeleteConfirmTitle => 'Biztosan törlöd?';

  @override
  String get obsDeleteConfirmBody =>
      'A megfigyelés és a hozzá tartozó fotó véglegesen törlődik.';

  @override
  String get obsDeleted => 'Megfigyelés törölve.';

  @override
  String get obsSpeciesSaved => 'A faj neve mentve.';

  @override
  String get tapForFullSize => 'Koppints a teljes mérethez';

  @override
  String get confirmTitle => 'Mentse a megfigyelést?';

  @override
  String get confirmSave => 'Mentés';

  @override
  String get confirmDiscard => 'Elvetés';

  @override
  String get identifyTitle => 'Mit fotóztál?';

  @override
  String get identifyManual => 'Egyik sem — kézi keresés';

  @override
  String get identifyManualHint =>
      'Faj keresése a Catalogue of Life adatbázisban';

  @override
  String get identifySkip => 'Nem tudom / kihagyom';

  @override
  String get identifyNone => 'Nem sikerült azonosítani';

  @override
  String get mapTitle => 'Térkép';

  @override
  String mapObservationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count megfigyelés',
      one: '1 megfigyelés',
      zero: 'Nincs megfigyelés',
    );
    return '$_temp0';
  }

  @override
  String get mapEmpty =>
      'Még nincs megfigyelésed. Készíts egyet, és megjelenik itt a térképen.';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get settingsLanguage => 'Nyelv';

  @override
  String get settingsSystemLanguage => 'Rendszer nyelve';
}
