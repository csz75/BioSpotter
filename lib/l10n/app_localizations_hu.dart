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
  String get loginTagline => 'Fedezd fel a természetet, egy fotóval';

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
  String get loginEmailNotConfirmed =>
      'Erősítsd meg az e-mail-címed, majd próbáld újra.';

  @override
  String loginError(String error) {
    return 'Hiba történt: $error';
  }

  @override
  String get verifyEmailTitle => 'E-mail megerősítése';

  @override
  String get verifyEmailHeading => 'Erősítsd meg az e-mail-címed';

  @override
  String verifyEmailBody(String email) {
    return 'Elküldtük a megerősítő levelet ide: $email. A levélben lévő linkre kattintva aktiválódik a fiókod.';
  }

  @override
  String get verifyEmailResend => 'Levél újraküldése';

  @override
  String get verifyEmailResent => 'Elküldtük újra a megerősítő levelet.';

  @override
  String get verifyEmailBack => 'Vissza a belépéshez';

  @override
  String get verifyEmailImDone => 'Már megerősítettem';

  @override
  String get verifyEmailNotYet =>
      'A fiók még nincs megerősítve. Nyisd meg a levélben lévő linket.';

  @override
  String get likeTooltip => 'Tetszik';

  @override
  String likeCount(int count) {
    return '$count kedvelés';
  }

  @override
  String get likeFailed => 'A kedvelés nem sikerült.';

  @override
  String likeMineCount(int count) {
    return '$count kedvelés érkezett a megfigyelésedre';
  }

  @override
  String get likeMineNone => 'Még nincs kedvelés ezen a megfigyelésen';

  @override
  String get groupsTitle => 'Csoportok';

  @override
  String get groupsEmpty =>
      'Még nincs csoportod. Hozz létre egyet, vagy csatlakozz egy meghívó kóddal.';

  @override
  String get groupsCreate => 'Új csoport';

  @override
  String get groupsJoin => 'Csatlakozás kóddal';

  @override
  String get groupsName => 'Csoport neve';

  @override
  String get groupsDescription => 'Leírás (opcionális)';

  @override
  String get groupsInviteCode => 'Meghívó kód';

  @override
  String get groupsCreateButton => 'Létrehozás';

  @override
  String get groupsJoinButton => 'Csatlakozás';

  @override
  String get groupsJoinHint => 'pl. 5B-4K7X';

  @override
  String get groupsInvalidCode => 'Érvénytelen meghívó kód.';

  @override
  String get groupsJoined => 'Sikeresen csatlakoztál.';

  @override
  String get groupsCreated => 'Csoport létrehozva.';

  @override
  String get groupInviteCodeLabel => 'Meghívó kód';

  @override
  String get groupCopyCode => 'Kód másolása';

  @override
  String get groupCodeCopied => 'Kód a vágólapra másolva.';

  @override
  String get groupEmpty => 'Még nincs megfigyelés ebben a csoportban.';

  @override
  String get groupNone => 'Nyilvános (nincs csoport)';

  @override
  String get groupPickTitle => 'Hova kerüljön a megfigyelés?';

  @override
  String get groupVisibilityTitle => 'Látszódjon nyilvánosan is?';

  @override
  String get groupVisibilityBody =>
      'Ha nyilvános, a megfigyelés a közösségi nézetben is megjelenik. Ha nem, csak a csoport tagjai látják.';

  @override
  String get groupVisibilityPublic => 'Nyilvános is';

  @override
  String get groupVisibilityGroupOnly => 'Csak a csoport';

  @override
  String get groupMembersTitle => 'Tagok';

  @override
  String get groupMemberOwner => 'Csoportgazda';

  @override
  String get groupRemoveMember => 'Tag eltávolítása';

  @override
  String groupRemoveMemberBody(String name) {
    return 'Biztosan eltávolítod $name tagot a csoportból?';
  }

  @override
  String get groupMemberRemoved => 'Tag eltávolítva.';

  @override
  String get groupLeave => 'Kilépés a csoportból';

  @override
  String get groupLeaveBody =>
      'A megfigyeléseid megmaradnak a csoportban, de te többé nem látod őket.';

  @override
  String get groupArchive => 'Csoport archiválása';

  @override
  String get groupArchiveBody =>
      'Az archivált csoportot senki nem látja többé. Biztos vagy benne?';

  @override
  String get groupArchived => 'Archiválva';

  @override
  String get groupArchivedSection => 'Archivált csoportok';

  @override
  String get groupRestore => 'Visszaállítás';

  @override
  String get groupRestored => 'A csoport visszaállítva.';

  @override
  String get bountyTitle => 'Kitűzések';

  @override
  String get bountyTabOpen => 'Nyitott';

  @override
  String get bountyTabMine => 'Sajátjaim';

  @override
  String get bountyCreate => 'Új kitűzés';

  @override
  String get bountyEmpty => 'Jelenleg nincs nyitott kitűzés.';

  @override
  String get bountyMineEmpty => 'Még nincs saját kitűzésed.';

  @override
  String get bountyPoints => 'pont';

  @override
  String get bountySlots => 'hely';

  @override
  String bountyDaysLeft(int days) {
    return '$days nap';
  }

  @override
  String get bountyExpires => 'Lejár';

  @override
  String get bountyStatusPending => 'Moderátor jóváhagyására vár';

  @override
  String get bountyStatusPaid => 'Lezárva — a jutalom kifizetve';

  @override
  String get bountyStatusExpired => 'Lejárt';

  @override
  String get bountySubmit => 'Megfigyelést jelentek be';

  @override
  String get bountyMyClaims => 'A beküldéseim';

  @override
  String get bountyClaims => 'Beküldések';

  @override
  String get bountyNoClaims => 'Még nincs beküldés.';

  @override
  String get bountyNoEligible =>
      'Nincs olyan megfigyelésed, ami illik ehhez a kitűzéshez.';

  @override
  String get bountyPickObservation => 'Melyik megfigyelést küldöd be?';

  @override
  String get bountyClaimSent => 'A beküldést elküldtük.';

  @override
  String get bountyAccept => 'Elfogadás';

  @override
  String get bountyReject => 'Elutasítás';

  @override
  String get bountyAccepted => 'Elfogadva — a pont jóváírva.';

  @override
  String get bountyRejected => 'Elutasítva.';

  @override
  String get bountyClaimPending => 'Elbírálásra vár';

  @override
  String get bountyClaimAccepted => 'Elfogadva';

  @override
  String get bountyClaimRejected => 'Elutasítva';

  @override
  String get bountyFieldTitle => 'Kitűzés címe';

  @override
  String get bountyFieldDescription => 'Leírás (opcionális)';

  @override
  String get bountyFieldPoints => 'Jutalom (pont)';

  @override
  String get bountyFieldWinners => 'Nyertesek száma';

  @override
  String get bountyPickSpecies => 'Faj kiválasztása (opcionális)';

  @override
  String get bountyPickExpiry => 'Határidő kiválasztása';

  @override
  String get bountyCreateButton => 'Kitűzés létrehozása';

  @override
  String get bountyCreated =>
      'A kitűzés létrejött — moderátor jóváhagyására vár.';

  @override
  String get bountyTitleRequired => 'A cím megadása kötelező.';

  @override
  String get bountyPointsRequired => 'A jutalom több mint 0 pont kell legyen.';

  @override
  String get bountyApprovalNote =>
      'A kitűzés moderátor jóváhagyása után válik nyilvánossá. Kitűzést csak prémium előfizetők hozhatnak létre.';

  @override
  String get moderatorTitle => 'Moderátor';

  @override
  String get moderatorSubtitle => 'Kitűzések és bejelentések kezelése';

  @override
  String get moderatorTabBounties => 'Kitűzések';

  @override
  String get moderatorTabReports => 'Bejelentések';

  @override
  String get moderatorNoBounties => 'Nincs jóváhagyásra váró kitűzés.';

  @override
  String get moderatorNoReports => 'Nincs bejelentett megfigyelés.';

  @override
  String get moderatorApprove => 'Jóváhagyás';

  @override
  String get moderatorReject => 'Elutasítás';

  @override
  String get moderatorRejectBounty => 'Kitűzés elutasítása';

  @override
  String moderatorRejectBountyBody(String title) {
    return 'Biztosan elutasítod a(z) „$title” kitűzést?';
  }

  @override
  String get moderatorBountyApproved => 'A kitűzés jóváhagyva és nyilvános.';

  @override
  String get moderatorBountyRejected => 'A kitűzés elutasítva.';

  @override
  String get moderatorObsPublish => 'Közzététel';

  @override
  String get moderatorObsReject => 'Eltávolítás';

  @override
  String get moderatorObsPublished => 'A megfigyelés közzétéve.';

  @override
  String get moderatorObsRejected => 'A megfigyelés elutasítva.';

  @override
  String get moderatorReportReason => 'Bejelentés oka';

  @override
  String get moderatorNoReason => 'nincs megadva';

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
  String get premiumScreenTitle => 'Prémium előfizetés';

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
  String get premiumManage => 'Kezelés';

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

  @override
  String get settingsAppearance => 'Megjelenés';

  @override
  String get settingsThemeSystem => 'Rendszer';

  @override
  String get settingsThemeLight => 'Világos';

  @override
  String get settingsThemeDark => 'Sötét';

  @override
  String get navHome => 'Kezdőlap';

  @override
  String get navMap => 'Térkép';

  @override
  String get navCamera => 'Kamera';

  @override
  String get navObservations => 'Megfigyelések';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeSubtitle =>
      'Fedezd fel és azonosítsd a környezeted élővilágát';

  @override
  String get homeNewObservationHint => 'Fotózz egy fajt, és azonosítsd';

  @override
  String get homeObservationsLabel => 'Megfigyelés';

  @override
  String get homeSpeciesLabel => 'Azonosított faj';

  @override
  String get homeRecent => 'Legutóbbi megfigyelések';

  @override
  String get homeGroups => 'Csoportok';

  @override
  String get homeGroupsHint =>
      'Csatlakozz közösségekhez, kövesd mások észleléseit';

  @override
  String get homeBounties => 'Kitűzések';

  @override
  String get homeBountiesHint => 'Keress ritka fajokat, szerezz pontokat';
}
