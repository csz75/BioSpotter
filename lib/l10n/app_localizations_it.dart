// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'BioSpotter';

  @override
  String get loginTitle => 'BioSpotter';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginDisplayName => 'Nome visualizzato';

  @override
  String get loginSignIn => 'Accedi';

  @override
  String get loginSignUp => 'Registrati';

  @override
  String get loginSwitchToSignUp => 'Non hai ancora un account? Registrati';

  @override
  String get loginSwitchToSignIn => 'Hai già un account? Accedi';

  @override
  String get loginEmailRequired => 'Inserisci il tuo indirizzo email';

  @override
  String get loginEmailInvalid => 'Indirizzo email non valido';

  @override
  String get loginPasswordTooShort =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String loginError(String error) {
    return 'Si è verificato un errore: $error';
  }

  @override
  String homeGreeting(String email) {
    return 'Ciao, $email!';
  }

  @override
  String get homeNewObservation => 'Nuova osservazione';

  @override
  String get homeMyObservations => 'Le mie osservazioni';

  @override
  String get homeMap => 'Mappa';

  @override
  String get homeLogout => 'Esci';

  @override
  String get cameraTitle => 'Nuova osservazione';

  @override
  String get cameraNoCamera =>
      'Nessuna fotocamera trovata su questo dispositivo.';

  @override
  String cameraInitFailed(String error) {
    return 'Impossibile avviare la fotocamera: $error';
  }

  @override
  String get cameraRetry => 'Riprova';

  @override
  String get cameraSaved => 'Osservazione salvata!';

  @override
  String cameraError(String error) {
    return 'Errore: $error';
  }

  @override
  String get locationServiceDisabled =>
      'I servizi di localizzazione sono disattivati. Attivali in Impostazioni → Privacy → Localizzazione.';

  @override
  String get locationPermissionDenied =>
      'Hai negato il permesso di localizzazione.';

  @override
  String get locationPermissionDeniedForever =>
      'L\'accesso alla posizione è bloccato definitivamente. Impostazioni → BioSpotter → Posizione.';

  @override
  String get locationUnavailable =>
      'Impossibile determinare la tua posizione. Esci all\'aperto o attendi qualche secondo e riprova.';

  @override
  String get observationsTitle => 'Le mie osservazioni';

  @override
  String get observationsEmpty => 'Non hai ancora osservazioni';

  @override
  String get observationsUnknownSpecies => 'Specie non identificata';

  @override
  String observationsError(String error) {
    return 'Errore: $error';
  }

  @override
  String observationsGps(String lat, String lng) {
    return 'GPS: $lat, $lng';
  }

  @override
  String observationsDateTime(String date) {
    return 'Data: $date';
  }

  @override
  String get searchTitle => 'Cerca specie';

  @override
  String get searchHint => 'Digita il nome di una specie...';

  @override
  String get searchStartHint =>
      'Inizia a digitare per cercare una specie.\nPuoi inserire un nome scientifico o comune.';

  @override
  String get searchNoResults => 'Nessun risultato';

  @override
  String get searchTryOtherLanguage =>
      'Prova un\'altra lingua o inserisci il nome scientifico.';

  @override
  String get searchLanguage => 'Lingua:';

  @override
  String get searchFieldHint => 'Cerca per nome di specie...';

  @override
  String get searchClear => 'Cancella filtri';

  @override
  String searchResultCount(int count) {
    return '$count risultati';
  }

  @override
  String get searchGroupPlants => 'Piante';

  @override
  String get searchGroupAnimals => 'Animali';

  @override
  String get searchGroupInsects => 'Insetti';

  @override
  String get searchGroupFungi => 'Funghi';

  @override
  String get searchIdentified => 'Identificato';

  @override
  String get searchUnidentified => 'Non identificato';

  @override
  String get searchFromDate => 'Da';

  @override
  String get searchToDate => 'A';

  @override
  String get searchTabMine => 'Mie';

  @override
  String get searchTabCommunity => 'Comunità';

  @override
  String get searchCommunityEmpty =>
      'Nessuna osservazione della comunità corrisponde ai filtri.';

  @override
  String get searchCommunityLoad => 'Carica dati della comunità';

  @override
  String get premiumTitle => 'Abbonamento Premium';

  @override
  String get premiumSubtitle =>
      'Per vedere le osservazioni della comunità è necessario un abbonamento.';

  @override
  String get premiumFeature1 => 'Osservazioni di tutti';

  @override
  String get premiumFeature2 => 'Ricerca per zona';

  @override
  String get premiumFeature3 => 'Elenco delle specie di tutta la regione';

  @override
  String get premiumPrice => '3 € / mese';

  @override
  String get premiumSubscribe => 'Abbonati';

  @override
  String get premiumTestNote =>
      'Modalità sviluppatore — per ora senza pagamento.';

  @override
  String get premiumTestTitle => 'Attivare Premium?';

  @override
  String get premiumTestBody =>
      'Questo è un test sviluppatore: il piano Premium si attiva senza pagamento.';

  @override
  String get premiumActivated => 'Premium attivato (test).';

  @override
  String get premiumActive => 'Abbonamento Premium attivo';

  @override
  String get premiumDeactivate => 'Ripristina a gratuito (test)';

  @override
  String get premiumDeactivated => 'Ripristinato a gratuito.';

  @override
  String get zoneNone => 'Nessun filtro zona';

  @override
  String get zoneHere => 'Zona: la mia posizione attuale';

  @override
  String get zoneClear => 'Cancella zona';

  @override
  String zoneActive(int km) {
    return 'Zona: entro $km km';
  }

  @override
  String get zoneNoPermission =>
      'Il filtro zona richiede il permesso di localizzazione.';

  @override
  String get zoneFailed => 'Impossibile determinare la posizione.';

  @override
  String get deleteAccountTitle => 'Elimina account';

  @override
  String get deleteAccountHeading =>
      'Sei sicuro di voler eliminare il tuo account?';

  @override
  String get deleteAccountBody1 =>
      'Il tuo nome e la tua e-mail saranno rimossi e sostituiti con un identificatore casuale. Potrai registrarti di nuovo più tardi con lo stesso indirizzo.';

  @override
  String get deleteAccountBody2 =>
      'Le tue osservazioni rimangono in forma anonima: la specie, il luogo e la data restano, ma non possono più essere collegati a te. Se non lo vuoi, elimina prima le osservazioni che non vuoi lasciare.';

  @override
  String get deleteAccountOpenMine => 'Apri le mie osservazioni';

  @override
  String get deleteAccountConfirm =>
      'Confermo di voler eliminare il mio account';

  @override
  String get deleteAccountCancel => 'Annulla';

  @override
  String get deleteAccountButton => 'Elimina account';

  @override
  String get deleteAccountDone =>
      'Il tuo account è stato eliminato. Puoi registrarti di nuovo con la tua e-mail.';

  @override
  String get deleteAccountFailed =>
      'Eliminazione dell\'account non riuscita. Riprova.';

  @override
  String mapCommunityCount(int count) {
    return 'Comunità: $count';
  }

  @override
  String get mapCommunityToggle => 'Comunità';

  @override
  String get mapCommunityLocked => 'Premium';

  @override
  String get searchKingdom => 'Regno';

  @override
  String get searchFamily => 'Famiglia';

  @override
  String get searchGbifKey => 'Chiave GBIF';

  @override
  String get searchVernaculars => 'Nomi in altre lingue';

  @override
  String get searchChoose => 'Scegli questa specie';

  @override
  String get searchKingdomAnimalia => 'Animali';

  @override
  String get searchKingdomPlantae => 'Piante';

  @override
  String get searchKingdomFungi => 'Funghi';

  @override
  String get obsSetSpecies => 'Imposta / cambia specie';

  @override
  String get obsReidentify => 'Ridentifica';

  @override
  String get obsDelete => 'Elimina osservazione';

  @override
  String get obsDeleteConfirmTitle => 'Eliminare questa osservazione?';

  @override
  String get obsDeleteConfirmBody =>
      'L\'osservazione e la sua foto verranno eliminate definitivamente.';

  @override
  String get obsDeleted => 'Osservazione eliminata.';

  @override
  String get obsSpeciesSaved => 'Nome della specie salvato.';

  @override
  String get tapForFullSize => 'Tocca per dimensione reale';

  @override
  String get confirmTitle => 'Salvare questa osservazione?';

  @override
  String get confirmSave => 'Salva';

  @override
  String get confirmDiscard => 'Scarta';

  @override
  String get identifyTitle => 'Cosa hai fotografato?';

  @override
  String get identifyManual => 'Nessuna — ricerca manuale';

  @override
  String get identifyManualHint =>
      'Cerca una specie nel database Catalogue of Life';

  @override
  String get identifySkip => 'Non lo so / salta';

  @override
  String get identifyNone => 'Impossibile identificare';

  @override
  String get mapTitle => 'Mappa';

  @override
  String mapObservationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count osservazioni',
      one: '1 osservazione',
      zero: 'Nessuna osservazione',
    );
    return '$_temp0';
  }

  @override
  String get mapEmpty =>
      'Non hai ancora osservazioni. Fanne una e apparirà qui sulla mappa.';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsSystemLanguage => 'Lingua di sistema';
}
