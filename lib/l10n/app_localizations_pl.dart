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
