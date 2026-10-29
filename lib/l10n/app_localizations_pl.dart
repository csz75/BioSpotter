// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'BioSpotter';

  @override
  String get loginTitle => 'BioSpotter';

  @override
  String get loginTagline => 'Odkrywaj naturę, zdjęcie po zdjęciu';

  @override
  String get loginEmail => 'E-mail';

  @override
  String get loginPassword => 'Hasło';

  @override
  String get loginDisplayName => 'Nazwa wyświetlana';

  @override
  String get loginSignIn => 'Zaloguj się';

  @override
  String get loginSignUp => 'Zarejestruj się';

  @override
  String get loginSwitchToSignUp => 'Nie masz jeszcze konta? Zarejestruj się';

  @override
  String get loginSwitchToSignIn => 'Masz już konto? Zaloguj się';

  @override
  String get loginEmailRequired => 'Podaj swój adres e-mail';

  @override
  String get loginEmailInvalid => 'Nieprawidłowy adres e-mail';

  @override
  String get loginPasswordTooShort => 'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get loginEmailNotConfirmed =>
      'Potwierdź swój adres e-mail i spróbuj ponownie.';

  @override
  String loginError(String error) {
    return 'Wystąpił błąd: $error';
  }

  @override
  String get verifyEmailTitle => 'Weryfikacja e-mail';

  @override
  String get verifyEmailHeading => 'Potwierdź swój adres e-mail';

  @override
  String verifyEmailBody(String email) {
    return 'Wysłaliśmy e-mail potwierdzający na $email. Kliknij link, aby aktywować konto.';
  }

  @override
  String get verifyEmailResend => 'Wyślij e-mail ponownie';

  @override
  String get verifyEmailResent => 'Ponownie wysłaliśmy e-mail potwierdzający.';

  @override
  String get verifyEmailBack => 'Powrót do logowania';

  @override
  String get verifyEmailImDone => 'Już potwierdziłem';

  @override
  String get verifyEmailNotYet =>
      'Konto nie jest jeszcze potwierdzone. Otwórz link w e-mailu.';

  @override
  String get likeTooltip => 'Lubię to';

  @override
  String likeCount(int count) {
    return '$count polubień';
  }

  @override
  String get likeFailed => 'Nie udało się zapisać.';

  @override
  String likeMineCount(int count) {
    return '$count polubień na twojej obserwacji';
  }

  @override
  String get likeMineNone => 'Jeszcze brak polubień na tej obserwacji';

  @override
  String get groupsTitle => 'Grupy';

  @override
  String get groupsEmpty =>
      'Nie masz jeszcze grup. Utwórz jedną lub dołącz kodem.';

  @override
  String get groupsCreate => 'Nowa grupa';

  @override
  String get groupsJoin => 'Dołącz kodem';

  @override
  String get groupsName => 'Nazwa grupy';

  @override
  String get groupsDescription => 'Opis (opcjonalnie)';

  @override
  String get groupsInviteCode => 'Kod zaproszenia';

  @override
  String get groupsCreateButton => 'Utwórz';

  @override
  String get groupsJoinButton => 'Dołącz';

  @override
  String get groupsJoinHint => 'np. 5B-4K7X';

  @override
  String get groupsInvalidCode => 'Nieprawidłowy kod zaproszenia.';

  @override
  String get groupsJoined => 'Dołączyłeś pomyślnie.';

  @override
  String get groupsCreated => 'Grupa utworzona.';

  @override
  String get groupInviteCodeLabel => 'Kod zaproszenia';

  @override
  String get groupCopyCode => 'Kopiuj kod';

  @override
  String get groupCodeCopied => 'Kod skopiowany do schowka.';

  @override
  String get groupEmpty => 'Brak obserwacji w tej grupie.';

  @override
  String get groupNone => 'Publiczne (bez grupy)';

  @override
  String get groupPickTitle => 'Gdzie ma trafić obserwacja?';

  @override
  String get groupVisibilityTitle => 'Pokazać też publicznie?';

  @override
  String get groupVisibilityBody =>
      'Jeśli publiczna, obserwacja pojawi się także w widoku społeczności. W przeciwnym razie zobaczą ją tylko członkowie twojej grupy.';

  @override
  String get groupVisibilityPublic => 'Też publiczna';

  @override
  String get groupVisibilityGroupOnly => 'Tylko grupa';

  @override
  String get groupMembersTitle => 'Członkowie';

  @override
  String get groupMemberOwner => 'Właściciel grupy';

  @override
  String get groupRemoveMember => 'Usuń członka';

  @override
  String groupRemoveMemberBody(String name) {
    return 'Usunąć $name z grupy?';
  }

  @override
  String get groupMemberRemoved => 'Członek usunięty.';

  @override
  String get groupLeave => 'Opuść grupę';

  @override
  String get groupLeaveBody =>
      'Twoje obserwacje zostaną w grupie, ale nie będziesz ich już widzieć.';

  @override
  String get groupArchive => 'Zarchiwizuj grupę';

  @override
  String get groupArchiveBody =>
      'Zarchiwizowana grupa jest ukryta dla wszystkich. Jesteś pewien?';

  @override
  String get groupArchived => 'Zarchiwizowane';

  @override
  String get groupArchivedSection => 'Zarchiwizowane grupy';

  @override
  String get groupRestore => 'Przywróć';

  @override
  String get groupRestored => 'Grupa przywrócona.';

  @override
  String get bountyTitle => 'Nagrody';

  @override
  String get bountyTabOpen => 'Otwarte';

  @override
  String get bountyTabMine => 'Moje';

  @override
  String get bountyCreate => 'Nowa nagroda';

  @override
  String get bountyEmpty => 'Brak otwartych nagród.';

  @override
  String get bountyMineEmpty => 'Nie masz jeszcze nagród.';

  @override
  String get bountyPoints => 'punktów';

  @override
  String get bountySlots => 'miejsc';

  @override
  String bountyDaysLeft(int days) {
    return '$days dni';
  }

  @override
  String get bountyExpires => 'Wygasa';

  @override
  String get bountyStatusPending => 'Oczekuje na zatwierdzenie';

  @override
  String get bountyStatusPaid => 'Zamknięta — nagroda wypłacona';

  @override
  String get bountyStatusExpired => 'Wygasła';

  @override
  String get bountySubmit => 'Zgłoś obserwację';

  @override
  String get bountyMyClaims => 'Moje zgłoszenia';

  @override
  String get bountyClaims => 'Zgłoszenia';

  @override
  String get bountyNoClaims => 'Brak zgłoszeń.';

  @override
  String get bountyNoEligible => 'Brak obserwacji pasującej do tej nagrody.';

  @override
  String get bountyPickObservation => 'Którą obserwację zgłaszasz?';

  @override
  String get bountyClaimSent => 'Zgłoszenie wysłane.';

  @override
  String get bountyAccept => 'Akceptuj';

  @override
  String get bountyReject => 'Odrzuć';

  @override
  String get bountyAccepted => 'Zaakceptowano — punkty naliczone.';

  @override
  String get bountyRejected => 'Odrzucono.';

  @override
  String get bountyClaimPending => 'Oczekuje na ocenę';

  @override
  String get bountyClaimAccepted => 'Zaakceptowane';

  @override
  String get bountyClaimRejected => 'Odrzucone';

  @override
  String get bountyFieldTitle => 'Tytuł nagrody';

  @override
  String get bountyFieldDescription => 'Opis (opcjonalnie)';

  @override
  String get bountyFieldPoints => 'Nagroda (punkty)';

  @override
  String get bountyFieldWinners => 'Liczba zwycięzców';

  @override
  String get bountyPickSpecies => 'Wybierz gatunek (opcjonalnie)';

  @override
  String get bountyPickExpiry => 'Wybierz termin';

  @override
  String get bountyCreateButton => 'Utwórz nagrodę';

  @override
  String get bountyCreated => 'Nagroda utworzona — oczekuje na zatwierdzenie.';

  @override
  String get bountyTitleRequired => 'Tytuł jest wymagany.';

  @override
  String get bountyPointsRequired => 'Nagroda musi być większa niż 0 punktów.';

  @override
  String get bountyApprovalNote =>
      'Nagroda staje się publiczna po zatwierdzeniu. Tylko subskrybenci premium mogą je tworzyć.';

  @override
  String get moderatorTitle => 'Moderator';

  @override
  String get moderatorSubtitle => 'Zarządzaj nagrodami i zgłoszeniami';

  @override
  String get moderatorTabBounties => 'Nagrody';

  @override
  String get moderatorTabReports => 'Zgłoszenia';

  @override
  String get moderatorNoBounties => 'Brak nagród oczekujących.';

  @override
  String get moderatorNoReports => 'Brak zgłoszonych obserwacji.';

  @override
  String get moderatorApprove => 'Zatwierdź';

  @override
  String get moderatorReject => 'Odrzuć';

  @override
  String get moderatorRejectBounty => 'Odrzuć nagrodę';

  @override
  String moderatorRejectBountyBody(String title) {
    return 'Odrzucić nagrodę „$title”?';
  }

  @override
  String get moderatorBountyApproved => 'Nagroda zatwierdzona i publiczna.';

  @override
  String get moderatorBountyRejected => 'Nagroda odrzucona.';

  @override
  String get moderatorObsPublish => 'Opublikuj';

  @override
  String get moderatorObsReject => 'Usuń';

  @override
  String get moderatorObsPublished => 'Obserwacja opublikowana.';

  @override
  String get moderatorObsRejected => 'Obserwacja odrzucona.';

  @override
  String get moderatorReportReason => 'Powód zgłoszenia';

  @override
  String get moderatorNoReason => 'nie podano';

  @override
  String homeGreeting(String email) {
    return 'Cześć, $email!';
  }

  @override
  String get homeNewObservation => 'Nowa obserwacja';

  @override
  String get homeMyObservations => 'Moje obserwacje';

  @override
  String get homeMap => 'Mapa';

  @override
  String get homeLogout => 'Wyloguj się';

  @override
  String get cameraTitle => 'Nowa obserwacja';

  @override
  String get cameraNoCamera => 'Nie znaleziono aparatu na tym urządzeniu.';

  @override
  String cameraInitFailed(String error) {
    return 'Nie udało się uruchomić aparatu: $error';
  }

  @override
  String get cameraRetry => 'Spróbuj ponownie';

  @override
  String get cameraSaved => 'Obserwacja zapisana!';

  @override
  String cameraError(String error) {
    return 'Błąd: $error';
  }

  @override
  String get locationServiceDisabled =>
      'Usługi lokalizacyjne są wyłączone. Włącz je w Ustawienia → Prywatność → Usługi lokalizacyjne.';

  @override
  String get locationPermissionDenied =>
      'Odmówiłeś uprawnienia do lokalizacji.';

  @override
  String get locationPermissionDeniedForever =>
      'Dostęp do lokalizacji jest trwale zablokowany. Ustawienia → BioSpotter → Lokalizacja.';

  @override
  String get locationUnavailable =>
      'Nie udało się ustalić Twojej lokalizacji. Wyjdź na zewnątrz lub poczekaj kilka sekund i spróbuj ponownie.';

  @override
  String get observationsTitle => 'Moje obserwacje';

  @override
  String get observationsEmpty => 'Nie masz jeszcze żadnych obserwacji';

  @override
  String get observationsUnknownSpecies => 'Nieznany gatunek';

  @override
  String observationsError(String error) {
    return 'Błąd: $error';
  }

  @override
  String observationsGps(String lat, String lng) {
    return 'GPS: $lat, $lng';
  }

  @override
  String observationsDateTime(String date) {
    return 'Czas: $date';
  }

  @override
  String get searchTitle => 'Szukaj gatunku';

  @override
  String get searchHint => 'Wpisz nazwę gatunku...';

  @override
  String get searchStartHint =>
      'Zacznij pisać, aby wyszukać gatunek.\nMożesz wpisać nazwę naukową lub potoczną.';

  @override
  String get searchNoResults => 'Brak wyników';

  @override
  String get searchTryOtherLanguage =>
      'Spróbuj innego języka lub wpisz nazwę naukową.';

  @override
  String get searchLanguage => 'Język:';

  @override
  String get searchFieldHint => 'Szukaj według nazwy gatunku...';

  @override
  String get searchClear => 'Wyczyść filtry';

  @override
  String searchResultCount(int count) {
    return '$count wyników';
  }

  @override
  String get searchGroupPlants => 'Rośliny';

  @override
  String get searchGroupAnimals => 'Zwierzęta';

  @override
  String get searchGroupInsects => 'Owady';

  @override
  String get searchGroupFungi => 'Grzyby';

  @override
  String get searchIdentified => 'Zidentyfikowane';

  @override
  String get searchUnidentified => 'Niezidentyfikowane';

  @override
  String get searchFromDate => 'Od';

  @override
  String get searchToDate => 'Do';

  @override
  String get searchTabMine => 'Moje';

  @override
  String get searchTabCommunity => 'Społeczność';

  @override
  String get searchCommunityEmpty =>
      'Brak obserwacji społeczności pasujących do filtrów.';

  @override
  String get searchCommunityLoad => 'Wczytaj dane społeczności';

  @override
  String get premiumTitle => 'Subskrypcja Premium';

  @override
  String get premiumSubtitle =>
      'Do przeglądania obserwacji społeczności wymagana jest subskrypcja.';

  @override
  String get premiumFeature1 => 'Obserwacje wszystkich';

  @override
  String get premiumFeature2 => 'Wyszukiwanie według obszaru';

  @override
  String get premiumFeature3 => 'Lista gatunków z całego regionu';

  @override
  String get premiumPrice => '3 € / miesiąc';

  @override
  String get premiumSubscribe => 'Subskrybuj';

  @override
  String get premiumTestNote => 'Tryb deweloperski — na razie bez płatności.';

  @override
  String get premiumTestTitle => 'Aktywować Premium?';

  @override
  String get premiumTestBody =>
      'To test deweloperski: plan Premium aktywuje się bez płatności.';

  @override
  String get premiumActivated => 'Premium aktywowane (test).';

  @override
  String get premiumActive => 'Subskrypcja Premium aktywna';

  @override
  String get premiumDeactivate => 'Przywróć darmowy (test)';

  @override
  String get premiumDeactivated => 'Przywrócono darmowy.';

  @override
  String get zoneNone => 'Brak filtra obszaru';

  @override
  String get zoneHere => 'Obszar: moja obecna lokalizacja';

  @override
  String get zoneClear => 'Wyczyść obszar';

  @override
  String zoneActive(int km) {
    return 'Obszar: w promieniu $km km';
  }

  @override
  String get zoneNoPermission =>
      'Filtr obszaru wymaga uprawnień do lokalizacji.';

  @override
  String get zoneFailed => 'Nie udało się ustalić lokalizacji.';

  @override
  String get deleteAccountTitle => 'Usuń konto';

  @override
  String get deleteAccountHeading => 'Czy na pewno chcesz usunąć swoje konto?';

  @override
  String get deleteAccountBody1 =>
      'Twoje imię i adres e-mail zostaną usunięte i zastąpione losowym identyfikatorem. Będziesz mógł zarejestrować się ponownie później z tym samym adresem.';

  @override
  String get deleteAccountBody2 =>
      'Twoje obserwacje pozostaną w formie anonimowej: gatunek, miejsce i data zostaną, ale nie będzie można ich już powiązać z Tobą. Jeśli tego nie chcesz, najpierw usuń obserwacje, których nie chcesz zostawiać.';

  @override
  String get deleteAccountOpenMine => 'Otwórz moje obserwacje';

  @override
  String get deleteAccountConfirm => 'Potwierdzam, że chcę usunąć swoje konto';

  @override
  String get deleteAccountCancel => 'Anuluj';

  @override
  String get deleteAccountButton => 'Usuń konto';

  @override
  String get deleteAccountDone =>
      'Twoje konto zostało usunięte. Możesz zarejestrować się ponownie ze swoim adresem e-mail.';

  @override
  String get deleteAccountFailed =>
      'Usunięcie konta nie powiodło się. Spróbuj ponownie.';

  @override
  String get legalPrivacy => 'Polityka prywatności';

  @override
  String get legalTerms => 'Warunki korzystania';

  @override
  String get legalDeletion => 'Usuwanie danych';

  @override
  String get reportButton => 'Zgłoś';

  @override
  String get reportTitle => 'Co chcesz zgłosić?';

  @override
  String get reportNotNature => 'Nieodpowiednia treść';

  @override
  String get reportViolent => 'Treść z przemocą';

  @override
  String get reportAdult => 'Treść dla dorosłych';

  @override
  String get reportOther => 'Inne';

  @override
  String get reportCancel => 'Anuluj';

  @override
  String get reportSent => 'Dziękujemy, otrzymaliśmy zgłoszenie.';

  @override
  String get reportFailed => 'Nie udało się wysłać zgłoszenia.';

  @override
  String get statusPending =>
      'Oczekuje na identyfikację — jeszcze niewidoczne.';

  @override
  String get statusFlagged => 'Zgłoszone — w moderacji.';

  @override
  String get statusRejected => 'Odrzucone.';

  @override
  String mapCommunityCount(int count) {
    return 'Społeczność: $count';
  }

  @override
  String get mapCommunityToggle => 'Społeczność';

  @override
  String get mapCommunityLocked => 'Premium';

  @override
  String get mapSearchHint => 'Szukaj według gatunku…';

  @override
  String get mapNoMatch => 'Brak wyników dla tego wyszukiwania.';

  @override
  String get searchKingdom => 'Królestwo';

  @override
  String get searchFamily => 'Rodzina';

  @override
  String get searchGbifKey => 'Klucz GBIF';

  @override
  String get searchVernaculars => 'Nazwy w innych językach';

  @override
  String get searchChoose => 'Wybierz ten gatunek';

  @override
  String get searchKingdomAnimalia => 'Zwierzęta';

  @override
  String get searchKingdomPlantae => 'Rośliny';

  @override
  String get searchKingdomFungi => 'Grzyby';

  @override
  String get obsSetSpecies => 'Ustaw / zmień gatunek';

  @override
  String get obsReidentify => 'Zidentyfikuj ponownie';

  @override
  String get obsDelete => 'Usuń obserwację';

  @override
  String get obsDeleteConfirmTitle => 'Usunąć tę obserwację?';

  @override
  String get obsDeleteConfirmBody =>
      'Obserwacja i jej zdjęcie zostaną trwale usunięte.';

  @override
  String get obsDeleted => 'Obserwacja usunięta.';

  @override
  String get obsSpeciesSaved => 'Nazwa gatunku zapisana.';

  @override
  String get tapForFullSize => 'Dotknij, aby powiększyć';

  @override
  String get confirmTitle => 'Zapisać tę obserwację?';

  @override
  String get confirmSave => 'Zapisz';

  @override
  String get confirmDiscard => 'Odrzuć';

  @override
  String get identifyTitle => 'Co sfotografowałeś?';

  @override
  String get identifyManual => 'Żadna — szukaj ręcznie';

  @override
  String get identifyManualHint => 'Szukaj gatunku w bazie Catalogue of Life';

  @override
  String get identifySkip => 'Nie wiem / pomiń';

  @override
  String get identifyNone => 'Nie udało się zidentyfikować';

  @override
  String get mapTitle => 'Mapa';

  @override
  String mapObservationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obserwacji',
      one: '1 obserwacja',
      zero: 'Brak obserwacji',
    );
    return '$_temp0';
  }

  @override
  String get mapEmpty =>
      'Nie masz jeszcze żadnych obserwacji. Zrób jedną, a pojawi się tutaj na mapie.';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsLanguage => 'Język';

  @override
  String get settingsSystemLanguage => 'Język systemu';

  @override
  String get settingsAppearance => 'Wygląd';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Jasny';

  @override
  String get settingsThemeDark => 'Ciemny';

  @override
  String get navHome => 'Start';

  @override
  String get navMap => 'Mapa';

  @override
  String get navCamera => 'Aparat';

  @override
  String get navObservations => 'Obserwacje';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeSubtitle => 'Odkrywaj i identyfikuj przyrodę wokół siebie';

  @override
  String get homeNewObservationHint => 'Sfotografuj gatunek i zidentyfikuj go';

  @override
  String get homeObservationsLabel => 'Obserwacje';

  @override
  String get homeSpeciesLabel => 'Zidentyfikowane gatunki';

  @override
  String get homeRecent => 'Ostatnie obserwacje';

  @override
  String get homeGroups => 'Grupy';

  @override
  String get homeGroupsHint => 'Dołącz do społeczności i śledź obserwacje';

  @override
  String get homeBounties => 'Nagrody';

  @override
  String get homeBountiesHint => 'Szukaj rzadkich gatunków i zdobywaj punkty';
}
