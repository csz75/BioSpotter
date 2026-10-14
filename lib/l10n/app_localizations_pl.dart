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
  String loginError(String error) {
    return 'Wystąpił błąd: $error';
  }

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
}
