// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BioSpotter';

  @override
  String get loginTitle => 'BioSpotter';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginDisplayName => 'Display name';

  @override
  String get loginSignIn => 'Sign in';

  @override
  String get loginSignUp => 'Sign up';

  @override
  String get loginSwitchToSignUp => 'No account yet? Sign up';

  @override
  String get loginSwitchToSignIn => 'Already have an account? Sign in';

  @override
  String get loginEmailRequired => 'Please enter your email address';

  @override
  String get loginEmailInvalid => 'Invalid email address';

  @override
  String get loginPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String loginError(String error) {
    return 'Something went wrong: $error';
  }

  @override
  String homeGreeting(String email) {
    return 'Hi, $email!';
  }

  @override
  String get homeNewObservation => 'New observation';

  @override
  String get homeMyObservations => 'My observations';

  @override
  String get homeMap => 'Map';

  @override
  String get homeLogout => 'Log out';

  @override
  String get cameraTitle => 'New observation';

  @override
  String get cameraNoCamera => 'No camera found on this device.';

  @override
  String cameraInitFailed(String error) {
    return 'The camera could not start: $error';
  }

  @override
  String get cameraRetry => 'Try again';

  @override
  String get cameraSaved => 'Observation saved!';

  @override
  String cameraError(String error) {
    return 'Error: $error';
  }

  @override
  String get locationServiceDisabled =>
      'Location services are turned off. Enable them in Settings → Privacy → Location Services.';

  @override
  String get locationPermissionDenied => 'You denied the location permission.';

  @override
  String get locationPermissionDeniedForever =>
      'Location access is permanently denied. Settings → BioSpotter → Location.';

  @override
  String get locationUnavailable =>
      'Could not determine your location. Go outside or wait a few seconds and try again.';

  @override
  String get observationsTitle => 'My observations';

  @override
  String get observationsEmpty => 'You have no observations yet';

  @override
  String get observationsUnknownSpecies => 'Unidentified species';

  @override
  String observationsError(String error) {
    return 'Error: $error';
  }

  @override
  String observationsGps(String lat, String lng) {
    return 'GPS: $lat, $lng';
  }

  @override
  String observationsDateTime(String date) {
    return 'Time: $date';
  }

  @override
  String get searchTitle => 'Search species';

  @override
  String get searchHint => 'Type a species name...';

  @override
  String get searchStartHint =>
      'Start typing to search for a species.\nYou can enter a scientific or common name.';

  @override
  String get searchNoResults => 'No results';

  @override
  String get searchTryOtherLanguage =>
      'Try another language, or enter the scientific name.';

  @override
  String get searchLanguage => 'Language:';

  @override
  String get searchFieldHint => 'Search by species name...';

  @override
  String get searchClear => 'Clear filters';

  @override
  String searchResultCount(int count) {
    return '$count results';
  }

  @override
  String get searchGroupPlants => 'Plants';

  @override
  String get searchGroupAnimals => 'Animals';

  @override
  String get searchGroupInsects => 'Insects';

  @override
  String get searchGroupFungi => 'Fungi';

  @override
  String get searchIdentified => 'Identified';

  @override
  String get searchUnidentified => 'Unidentified';

  @override
  String get searchFromDate => 'From';

  @override
  String get searchToDate => 'To';

  @override
  String get obsSetSpecies => 'Set / change species';

  @override
  String get obsReidentify => 'Re-identify';

  @override
  String get obsDelete => 'Delete observation';

  @override
  String get obsDeleteConfirmTitle => 'Delete this observation?';

  @override
  String get obsDeleteConfirmBody =>
      'The observation and its photo will be permanently deleted.';

  @override
  String get obsDeleted => 'Observation deleted.';

  @override
  String get obsSpeciesSaved => 'Species name saved.';

  @override
  String get tapForFullSize => 'Tap for full size';

  @override
  String get confirmTitle => 'Save this observation?';

  @override
  String get confirmSave => 'Save';

  @override
  String get confirmDiscard => 'Discard';

  @override
  String get identifyTitle => 'What did you photograph?';

  @override
  String get identifyManual => 'None of these — search manually';

  @override
  String get identifyManualHint =>
      'Search species in the Catalogue of Life database';

  @override
  String get identifySkip => 'I don\'t know / skip';

  @override
  String get identifyNone => 'Could not be identified';

  @override
  String get mapTitle => 'Map';

  @override
  String mapObservationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count observations',
      one: '1 observation',
      zero: 'No observations',
    );
    return '$_temp0';
  }

  @override
  String get mapEmpty =>
      'You have no observations yet. Take one and it will appear here on the map.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSystemLanguage => 'System language';
}
