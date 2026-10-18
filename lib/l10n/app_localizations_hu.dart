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
  String get searchFieldHint => 'Keresés fajnév alapján...';

  @override
  String get searchClear => 'Szűrők törlése';

  @override
  String searchResultCount(int count) {
    return '$count találat';
  }

  @override
  String get searchGroupPlants => 'Növények';

  @override
  String get searchGroupAnimals => 'Állatok';

  @override
  String get searchGroupInsects => 'Rovarok';

  @override
  String get searchGroupFungi => 'Gombák';

  @override
  String get searchIdentified => 'Azonosított';

  @override
  String get searchUnidentified => 'Azonosítatlan';

  @override
  String get searchFromDate => 'Ettől';

  @override
  String get searchToDate => 'Eddig';

  @override
  String get searchTabMine => 'Saját';

  @override
  String get searchTabCommunity => 'Közösségi';

  @override
  String get searchCommunityEmpty =>
      'Még nincs közösségi megfigyelés a szűrőkkel.';

  @override
  String get searchCommunityLoad => 'Közösségi adatok betöltése';

  @override
  String get premiumTitle => 'Prémium előfizetés';

  @override
  String get premiumSubtitle =>
      'A közösségi megfigyelések megtekintéséhez előfizetés szükséges.';

  @override
  String get premiumFeature1 => 'Mindenki megfigyelései';

  @override
  String get premiumFeature2 => 'Körzet szerinti keresés';

  @override
  String get premiumFeature3 => 'Fajlista az egész régióról';

  @override
  String get premiumPrice => '3 € / hó';

  @override
  String get premiumSubscribe => 'Előfizetek';

  @override
  String get premiumTestNote => 'Fejlesztői mód — egyelőre fizetés nélkül.';

  @override
  String get premiumTestTitle => 'Prémium bekapcsolása?';

  @override
  String get premiumTestBody =>
      'Ez egy fejlesztői teszt: a prémium csomag fizetés nélkül aktiválódik.';

  @override
  String get premiumActivated => 'Prémium aktiválva (teszt).';

  @override
  String get premiumActive => 'Prémium előfizetés aktív';

  @override
  String get premiumDeactivate => 'Visszaállítás ingyenesre (teszt)';

  @override
  String get premiumDeactivated => 'Visszaállítva ingyenesre.';

  @override
  String get zoneNone => 'Nincs körzet-szűrő';

  @override
  String get zoneHere => 'Körzet: a jelenlegi helyzetem';

  @override
  String get zoneClear => 'Körzet törlése';

  @override
  String zoneActive(int km) {
    return 'Körzet: $km km-en belül';
  }

  @override
  String get zoneNoPermission =>
      'A körzet-szűrőhöz helymeghatározás-engedély kell.';

  @override
  String get zoneFailed => 'Nem sikerült meghatározni a helyzetet.';

  @override
  String get deleteAccountTitle => 'Fiók törlése';

  @override
  String get deleteAccountHeading => 'Biztosan törlöd a fiókodat?';

  @override
  String get deleteAccountBody1 =>
      'A neved és az e-mail címed törlődik, és egy véletlen azonosítóra cserélődik. Ezzel a címmel később újra regisztrálhatsz.';

  @override
  String get deleteAccountBody2 =>
      'A megfigyeléseid anonim formában megmaradnak: a faj, a hely és a dátum bennmarad, de a személyedhez nem köthető. Ha ezt nem szeretnéd, előbb töröld kézzel azokat a megfigyeléseket, amelyeket nem akarsz itt hagyni.';

  @override
  String get deleteAccountOpenMine => 'Megfigyeléseim megnyitása';

  @override
  String get deleteAccountConfirm =>
      'Megerősítem, hogy törölni akarom a fiókomat';

  @override
  String get deleteAccountCancel => 'Mégsem';

  @override
  String get deleteAccountButton => 'Fiók törlése';

  @override
  String get deleteAccountDone =>
      'A fiókod törölve. Az e-mail címeddel újra regisztrálhatsz.';

  @override
  String get deleteAccountFailed =>
      'A fiók törlése nem sikerült. Próbáld újra.';

  @override
  String get legalPrivacy => 'Adatvédelmi tájékoztató';

  @override
  String get legalTerms => 'Felhasználási feltételek';

  @override
  String get legalDeletion => 'Adattörlési tudnivalók';

  @override
  String get reportButton => 'Bejelentés';

  @override
  String get reportTitle => 'Mit jelentessz be?';

  @override
  String get reportNotNature => 'Nem oda való tartalom';

  @override
  String get reportViolent => 'Erőszakos tartalom';

  @override
  String get reportAdult => 'Felnőtt tartalom';

  @override
  String get reportOther => 'Egyéb';

  @override
  String get reportCancel => 'Mégsem';

  @override
  String get reportSent => 'Köszönjük, megkaptuk a bejelentést.';

  @override
  String get reportFailed => 'A bejelentés nem sikerült.';

  @override
  String get statusPending =>
      'Azonosításra vár — még nem látszik a közösségben.';

  @override
  String get statusFlagged => 'Bejelentve — moderálás alatt.';

  @override
  String get statusRejected => 'Elutasítva.';

  @override
  String mapCommunityCount(int count) {
    return 'Közösségi: $count';
  }

  @override
  String get mapCommunityToggle => 'Közösségi';

  @override
  String get mapCommunityLocked => 'Prémium';

  @override
  String get mapSearchHint => 'Keresés fajra…';

  @override
  String get mapNoMatch => 'Nincs találat erre a keresésre.';

  @override
  String get searchKingdom => 'Ország';

  @override
  String get searchFamily => 'Család';

  @override
  String get searchGbifKey => 'GBIF azonosító';

  @override
  String get searchVernaculars => 'Nevek más nyelveken';

  @override
  String get searchChoose => 'Ezt a fajt választom';

  @override
  String get searchKingdomAnimalia => 'Állatok';

  @override
  String get searchKingdomPlantae => 'Növények';

  @override
  String get searchKingdomFungi => 'Gombák';

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
