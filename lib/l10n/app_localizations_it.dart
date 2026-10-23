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
  String get loginEmailNotConfirmed =>
      'Conferma il tuo indirizzo e-mail e riprova.';

  @override
  String loginError(String error) {
    return 'Si è verificato un errore: $error';
  }

  @override
  String get verifyEmailTitle => 'Verifica e-mail';

  @override
  String get verifyEmailHeading => 'Conferma il tuo indirizzo e-mail';

  @override
  String verifyEmailBody(String email) {
    return 'Abbiamo inviato un\'e-mail di conferma a $email. Clicca sul link per attivare il tuo account.';
  }

  @override
  String get verifyEmailResend => 'Invia di nuovo l\'e-mail';

  @override
  String get verifyEmailResent =>
      'Abbiamo inviato di nuovo l\'e-mail di conferma.';

  @override
  String get verifyEmailBack => 'Torna all\'accesso';

  @override
  String get verifyEmailImDone => 'L\'ho già confermato';

  @override
  String get verifyEmailNotYet =>
      'L\'account non è ancora confermato. Apri il link nell\'e-mail.';

  @override
  String get likeTooltip => 'Mi piace';

  @override
  String likeCount(int count) {
    return '$count mi piace';
  }

  @override
  String get likeFailed => 'Impossibile salvare.';

  @override
  String likeMineCount(int count) {
    return '$count mi piace sulla tua osservazione';
  }

  @override
  String get likeMineNone => 'Ancora nessun mi piace su questa osservazione';

  @override
  String get groupsTitle => 'Gruppi';

  @override
  String get groupsEmpty =>
      'Non hai ancora gruppi. Creane uno o unisciti con un codice.';

  @override
  String get groupsCreate => 'Nuovo gruppo';

  @override
  String get groupsJoin => 'Unisciti con codice';

  @override
  String get groupsName => 'Nome del gruppo';

  @override
  String get groupsDescription => 'Descrizione (facoltativa)';

  @override
  String get groupsInviteCode => 'Codice di invito';

  @override
  String get groupsCreateButton => 'Crea';

  @override
  String get groupsJoinButton => 'Unisciti';

  @override
  String get groupsJoinHint => 'es. 5B-4K7X';

  @override
  String get groupsInvalidCode => 'Codice di invito non valido.';

  @override
  String get groupsJoined => 'Ti sei unito con successo.';

  @override
  String get groupsCreated => 'Gruppo creato.';

  @override
  String get groupInviteCodeLabel => 'Codice di invito';

  @override
  String get groupCopyCode => 'Copia codice';

  @override
  String get groupCodeCopied => 'Codice copiato negli appunti.';

  @override
  String get groupEmpty => 'Ancora nessuna osservazione in questo gruppo.';

  @override
  String get groupNone => 'Pubblico (nessun gruppo)';

  @override
  String get groupPickTitle => 'Dove va l\'osservazione?';

  @override
  String get groupVisibilityTitle => 'Mostrare anche pubblicamente?';

  @override
  String get groupVisibilityBody =>
      'Se pubblica, l\'osservazione appare anche nella vista comunitaria. Altrimenti la vedono solo i membri del tuo gruppo.';

  @override
  String get groupVisibilityPublic => 'Anche pubblica';

  @override
  String get groupVisibilityGroupOnly => 'Solo gruppo';

  @override
  String get groupMembersTitle => 'Membri';

  @override
  String get groupMemberOwner => 'Proprietario del gruppo';

  @override
  String get groupRemoveMember => 'Rimuovi membro';

  @override
  String groupRemoveMemberBody(String name) {
    return 'Rimuovere $name dal gruppo?';
  }

  @override
  String get groupMemberRemoved => 'Membro rimosso.';

  @override
  String get groupLeave => 'Esci dal gruppo';

  @override
  String get groupLeaveBody =>
      'Le tue osservazioni restano nel gruppo, ma non le vedrai più.';

  @override
  String get groupArchive => 'Archivia gruppo';

  @override
  String get groupArchiveBody =>
      'Un gruppo archiviato è nascosto a tutti. Sei sicuro?';

  @override
  String get groupArchived => 'Archiviato';

  @override
  String get groupArchivedSection => 'Gruppi archiviati';

  @override
  String get groupRestore => 'Ripristina';

  @override
  String get groupRestored => 'Gruppo ripristinato.';

  @override
  String get bountyTitle => 'Ricompense';

  @override
  String get bountyTabOpen => 'Aperte';

  @override
  String get bountyTabMine => 'Le mie';

  @override
  String get bountyCreate => 'Nuova ricompensa';

  @override
  String get bountyEmpty => 'Nessuna ricompensa aperta al momento.';

  @override
  String get bountyMineEmpty => 'Non hai ancora ricompense.';

  @override
  String get bountyPoints => 'punti';

  @override
  String get bountySlots => 'posti';

  @override
  String bountyDaysLeft(int days) {
    return '$days giorni';
  }

  @override
  String get bountyExpires => 'Scade';

  @override
  String get bountyStatusPending => 'In attesa di approvazione';

  @override
  String get bountyStatusPaid => 'Chiusa — ricompensa pagata';

  @override
  String get bountyStatusExpired => 'Scaduta';

  @override
  String get bountySubmit => 'Invia un\'osservazione';

  @override
  String get bountyMyClaims => 'I miei invii';

  @override
  String get bountyClaims => 'Invii';

  @override
  String get bountyNoClaims => 'Ancora nessun invio.';

  @override
  String get bountyNoEligible => 'Nessuna osservazione corrisponde.';

  @override
  String get bountyPickObservation => 'Quale osservazione invii?';

  @override
  String get bountyClaimSent => 'Invio effettuato.';

  @override
  String get bountyAccept => 'Accetta';

  @override
  String get bountyReject => 'Rifiuta';

  @override
  String get bountyAccepted => 'Accettata — punti accreditati.';

  @override
  String get bountyRejected => 'Rifiutata.';

  @override
  String get bountyClaimPending => 'In attesa di revisione';

  @override
  String get bountyClaimAccepted => 'Accettata';

  @override
  String get bountyClaimRejected => 'Rifiutata';

  @override
  String get bountyFieldTitle => 'Titolo della ricompensa';

  @override
  String get bountyFieldDescription => 'Descrizione (facoltativa)';

  @override
  String get bountyFieldPoints => 'Ricompensa (punti)';

  @override
  String get bountyFieldWinners => 'Numero di vincitori';

  @override
  String get bountyPickSpecies => 'Scegli una specie (facoltativo)';

  @override
  String get bountyPickExpiry => 'Scegli una scadenza';

  @override
  String get bountyCreateButton => 'Crea ricompensa';

  @override
  String get bountyCreated => 'Ricompensa creata — in attesa di approvazione.';

  @override
  String get bountyTitleRequired => 'Il titolo è obbligatorio.';

  @override
  String get bountyPointsRequired =>
      'La ricompensa deve essere più di 0 punti.';

  @override
  String get bountyApprovalNote =>
      'La ricompensa diventa pubblica dopo l\'approvazione. Solo gli abbonati premium possono crearle.';

  @override
  String get moderatorTitle => 'Moderatore';

  @override
  String get moderatorSubtitle => 'Gestisci ricompense e segnalazioni';

  @override
  String get moderatorTabBounties => 'Ricompense';

  @override
  String get moderatorTabReports => 'Segnalazioni';

  @override
  String get moderatorNoBounties => 'Nessuna ricompensa in attesa.';

  @override
  String get moderatorNoReports => 'Nessuna osservazione segnalata.';

  @override
  String get moderatorApprove => 'Approva';

  @override
  String get moderatorReject => 'Rifiuta';

  @override
  String get moderatorRejectBounty => 'Rifiuta ricompensa';

  @override
  String moderatorRejectBountyBody(String title) {
    return 'Rifiutare la ricompensa «$title»?';
  }

  @override
  String get moderatorBountyApproved => 'Ricompensa approvata e pubblica.';

  @override
  String get moderatorBountyRejected => 'Ricompensa rifiutata.';

  @override
  String get moderatorObsPublish => 'Pubblica';

  @override
  String get moderatorObsReject => 'Rimuovi';

  @override
  String get moderatorObsPublished => 'Osservazione pubblicata.';

  @override
  String get moderatorObsRejected => 'Osservazione rifiutata.';

  @override
  String get moderatorReportReason => 'Motivo della segnalazione';

  @override
  String get moderatorNoReason => 'non indicato';

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
  String get legalPrivacy => 'Informativa sulla privacy';

  @override
  String get legalTerms => 'Termini di servizio';

  @override
  String get legalDeletion => 'Eliminazione dei dati';

  @override
  String get reportButton => 'Segnala';

  @override
  String get reportTitle => 'Cosa vuoi segnalare?';

  @override
  String get reportNotNature => 'Contenuto non appropriato';

  @override
  String get reportViolent => 'Contenuto violento';

  @override
  String get reportAdult => 'Contenuto per adulti';

  @override
  String get reportOther => 'Altro';

  @override
  String get reportCancel => 'Annulla';

  @override
  String get reportSent => 'Grazie, abbiamo ricevuto la tua segnalazione.';

  @override
  String get reportFailed => 'Impossibile inviare la segnalazione.';

  @override
  String get statusPending =>
      'In attesa di identificazione — non ancora visibile.';

  @override
  String get statusFlagged => 'Segnalato — in moderazione.';

  @override
  String get statusRejected => 'Rifiutato.';

  @override
  String mapCommunityCount(int count) {
    return 'Comunità: $count';
  }

  @override
  String get mapCommunityToggle => 'Comunità';

  @override
  String get mapCommunityLocked => 'Premium';

  @override
  String get mapSearchHint => 'Cerca per specie…';

  @override
  String get mapNoMatch => 'Nessun risultato per questa ricerca.';

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
