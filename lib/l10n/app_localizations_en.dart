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
  String get searchTabMine => 'Mine';

  @override
  String get searchTabCommunity => 'Community';

  @override
  String get searchCommunityEmpty =>
      'No community observations match the filters.';

  @override
  String get searchCommunityLoad => 'Load community data';

  @override
  String get premiumTitle => 'Premium subscription';

  @override
  String get premiumSubtitle =>
      'A subscription is required to view community observations.';

  @override
  String get premiumFeature1 => 'Everyone\'s observations';

  @override
  String get premiumFeature2 => 'Search by area';

  @override
  String get premiumFeature3 => 'Species list for the whole region';

  @override
  String get premiumPrice => '€3 / month';

  @override
  String get premiumSubscribe => 'Subscribe';

  @override
  String get premiumTestNote => 'Developer mode — no payment for now.';

  @override
  String get premiumTestTitle => 'Enable premium?';

  @override
  String get premiumTestBody =>
      'This is a developer test: the premium plan activates without payment.';

  @override
  String get premiumActivated => 'Premium activated (test).';

  @override
  String get premiumActive => 'Premium subscription active';

  @override
  String get premiumDeactivate => 'Reset to free (test)';

  @override
  String get premiumDeactivated => 'Reset to free.';

  @override
  String get zoneNone => 'No area filter';

  @override
  String get zoneHere => 'Area: my current location';

  @override
  String get zoneClear => 'Clear area';

  @override
  String zoneActive(int km) {
    return 'Area: within $km km';
  }

  @override
  String get zoneNoPermission => 'The area filter needs location permission.';

  @override
  String get zoneFailed => 'Could not determine your location.';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountHeading =>
      'Are you sure you want to delete your account?';

  @override
  String get deleteAccountBody1 =>
      'Your name and email will be removed and replaced with a random identifier. You can register again later with the same address.';

  @override
  String get deleteAccountBody2 =>
      'Your observations remain in anonymous form: the species, location and date stay, but can no longer be linked to you. If you do not want this, delete the observations you do not want to leave behind first.';

  @override
  String get deleteAccountOpenMine => 'Open my observations';

  @override
  String get deleteAccountConfirm => 'I confirm I want to delete my account';

  @override
  String get deleteAccountCancel => 'Cancel';

  @override
  String get deleteAccountButton => 'Delete account';

  @override
  String get deleteAccountDone =>
      'Your account has been deleted. You can register again with your email address.';

  @override
  String get deleteAccountFailed =>
      'Account deletion failed. Please try again.';

  @override
  String get searchKingdom => 'Kingdom';

  @override
  String get searchFamily => 'Family';

  @override
  String get searchGbifKey => 'GBIF key';

  @override
  String get searchVernaculars => 'Names in other languages';

  @override
  String get searchChoose => 'Choose this species';

  @override
  String get searchKingdomAnimalia => 'Animals';

  @override
  String get searchKingdomPlantae => 'Plants';

  @override
  String get searchKingdomFungi => 'Fungi';

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
