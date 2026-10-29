// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'BioSpotter';

  @override
  String get loginTitle => 'BioSpotter';

  @override
  String get loginTagline => 'Entdecke die Natur, Foto für Foto';

  @override
  String get loginEmail => 'E-Mail';

  @override
  String get loginPassword => 'Passwort';

  @override
  String get loginDisplayName => 'Anzeigename';

  @override
  String get loginSignIn => 'Anmelden';

  @override
  String get loginSignUp => 'Registrieren';

  @override
  String get loginSwitchToSignUp => 'Noch kein Konto? Registrieren';

  @override
  String get loginSwitchToSignIn => 'Schon ein Konto? Anmelden';

  @override
  String get loginEmailRequired => 'Bitte gib deine E-Mail-Adresse ein';

  @override
  String get loginEmailInvalid => 'Ungültige E-Mail-Adresse';

  @override
  String get loginPasswordTooShort =>
      'Das Passwort muss mindestens 6 Zeichen haben';

  @override
  String get loginEmailNotConfirmed =>
      'Bitte bestätige deine E-Mail-Adresse und versuche es erneut.';

  @override
  String loginError(String error) {
    return 'Ein Fehler ist aufgetreten: $error';
  }

  @override
  String get verifyEmailTitle => 'E-Mail bestätigen';

  @override
  String get verifyEmailHeading => 'Bestätige deine E-Mail-Adresse';

  @override
  String verifyEmailBody(String email) {
    return 'Wir haben eine Bestätigungs-E-Mail an $email gesendet. Klicke auf den Link, um dein Konto zu aktivieren.';
  }

  @override
  String get verifyEmailResend => 'E-Mail erneut senden';

  @override
  String get verifyEmailResent =>
      'Wir haben die Bestätigungs-E-Mail erneut gesendet.';

  @override
  String get verifyEmailBack => 'Zurück zur Anmeldung';

  @override
  String get verifyEmailImDone => 'Ich habe es bestätigt';

  @override
  String get verifyEmailNotYet =>
      'Das Konto ist noch nicht bestätigt. Öffne den Link in der E-Mail.';

  @override
  String get likeTooltip => 'Gefällt mir';

  @override
  String likeCount(int count) {
    return '$count Gefällt-mir';
  }

  @override
  String get likeFailed => 'Konnte nicht gespeichert werden.';

  @override
  String likeMineCount(int count) {
    return '$count Gefällt-mir auf deiner Beobachtung';
  }

  @override
  String get likeMineNone => 'Noch keine Gefällt-mir auf dieser Beobachtung';

  @override
  String get groupsTitle => 'Gruppen';

  @override
  String get groupsEmpty =>
      'Du hast noch keine Gruppen. Erstelle eine oder tritt mit einem Code bei.';

  @override
  String get groupsCreate => 'Neue Gruppe';

  @override
  String get groupsJoin => 'Mit Code beitreten';

  @override
  String get groupsName => 'Gruppenname';

  @override
  String get groupsDescription => 'Beschreibung (optional)';

  @override
  String get groupsInviteCode => 'Einladungscode';

  @override
  String get groupsCreateButton => 'Erstellen';

  @override
  String get groupsJoinButton => 'Beitreten';

  @override
  String get groupsJoinHint => 'z. B. 5B-4K7X';

  @override
  String get groupsInvalidCode => 'Ungültiger Einladungscode.';

  @override
  String get groupsJoined => 'Du bist erfolgreich beigetreten.';

  @override
  String get groupsCreated => 'Gruppe erstellt.';

  @override
  String get groupInviteCodeLabel => 'Einladungscode';

  @override
  String get groupCopyCode => 'Code kopieren';

  @override
  String get groupCodeCopied => 'Code in die Zwischenablage kopiert.';

  @override
  String get groupEmpty => 'Noch keine Beobachtungen in dieser Gruppe.';

  @override
  String get groupNone => 'Öffentlich (keine Gruppe)';

  @override
  String get groupPickTitle => 'Wohin soll die Beobachtung?';

  @override
  String get groupVisibilityTitle => 'Auch öffentlich zeigen?';

  @override
  String get groupVisibilityBody =>
      'Wenn öffentlich, erscheint die Beobachtung auch in der Gemeinschaftsansicht. Sonst sehen sie nur deine Gruppenmitglieder.';

  @override
  String get groupVisibilityPublic => 'Auch öffentlich';

  @override
  String get groupVisibilityGroupOnly => 'Nur Gruppe';

  @override
  String get groupMembersTitle => 'Mitglieder';

  @override
  String get groupMemberOwner => 'Gruppeneigentümer';

  @override
  String get groupRemoveMember => 'Mitglied entfernen';

  @override
  String groupRemoveMemberBody(String name) {
    return '$name aus der Gruppe entfernen?';
  }

  @override
  String get groupMemberRemoved => 'Mitglied entfernt.';

  @override
  String get groupLeave => 'Gruppe verlassen';

  @override
  String get groupLeaveBody =>
      'Deine Beobachtungen bleiben in der Gruppe, aber du siehst sie nicht mehr.';

  @override
  String get groupArchive => 'Gruppe archivieren';

  @override
  String get groupArchiveBody =>
      'Eine archivierte Gruppe ist für alle unsichtbar. Bist du sicher?';

  @override
  String get groupArchived => 'Archiviert';

  @override
  String get groupArchivedSection => 'Archivierte Gruppen';

  @override
  String get groupRestore => 'Wiederherstellen';

  @override
  String get groupRestored => 'Gruppe wiederhergestellt.';

  @override
  String get bountyTitle => 'Prämien';

  @override
  String get bountyTabOpen => 'Offen';

  @override
  String get bountyTabMine => 'Meine Prämien';

  @override
  String get bountyCreate => 'Neue Prämie';

  @override
  String get bountyEmpty => 'Derzeit keine offenen Prämien.';

  @override
  String get bountyMineEmpty => 'Du hast noch keine Prämien.';

  @override
  String get bountyPoints => 'Punkte';

  @override
  String get bountySlots => 'Plätze';

  @override
  String bountyDaysLeft(int days) {
    return '$days Tage';
  }

  @override
  String get bountyExpires => 'Läuft ab';

  @override
  String get bountyStatusPending => 'Wartet auf Moderatorfreigabe';

  @override
  String get bountyStatusPaid => 'Abgeschlossen — Belohnung ausgezahlt';

  @override
  String get bountyStatusExpired => 'Abgelaufen';

  @override
  String get bountySubmit => 'Beobachtung einreichen';

  @override
  String get bountyMyClaims => 'Meine Einreichungen';

  @override
  String get bountyClaims => 'Einreichungen';

  @override
  String get bountyNoClaims => 'Noch keine Einreichungen.';

  @override
  String get bountyNoEligible => 'Keine Beobachtung passt zu dieser Prämie.';

  @override
  String get bountyPickObservation => 'Welche Beobachtung reichst du ein?';

  @override
  String get bountyClaimSent => 'Einreichung gesendet.';

  @override
  String get bountyAccept => 'Annehmen';

  @override
  String get bountyReject => 'Ablehnen';

  @override
  String get bountyAccepted => 'Angenommen — Punkte gutgeschrieben.';

  @override
  String get bountyRejected => 'Abgelehnt.';

  @override
  String get bountyClaimPending => 'Wartet auf Prüfung';

  @override
  String get bountyClaimAccepted => 'Angenommen';

  @override
  String get bountyClaimRejected => 'Abgelehnt';

  @override
  String get bountyFieldTitle => 'Titel der Prämie';

  @override
  String get bountyFieldDescription => 'Beschreibung (optional)';

  @override
  String get bountyFieldPoints => 'Belohnung (Punkte)';

  @override
  String get bountyFieldWinners => 'Anzahl der Gewinner';

  @override
  String get bountyPickSpecies => 'Art auswählen (optional)';

  @override
  String get bountyPickExpiry => 'Frist wählen';

  @override
  String get bountyCreateButton => 'Prämie erstellen';

  @override
  String get bountyCreated => 'Prämie erstellt — wartet auf Moderatorfreigabe.';

  @override
  String get bountyTitleRequired => 'Titel ist erforderlich.';

  @override
  String get bountyPointsRequired => 'Belohnung muss mehr als 0 Punkte sein.';

  @override
  String get bountyApprovalNote =>
      'Die Prämie wird nach Moderatorfreigabe öffentlich. Nur Premium-Abonnenten können Prämien erstellen.';

  @override
  String get moderatorTitle => 'Moderator';

  @override
  String get moderatorSubtitle => 'Prämien und Meldungen verwalten';

  @override
  String get moderatorTabBounties => 'Prämien';

  @override
  String get moderatorTabReports => 'Meldungen';

  @override
  String get moderatorNoBounties => 'Keine Prämie wartet auf Freigabe.';

  @override
  String get moderatorNoReports => 'Keine gemeldeten Beobachtungen.';

  @override
  String get moderatorApprove => 'Freigeben';

  @override
  String get moderatorReject => 'Ablehnen';

  @override
  String get moderatorRejectBounty => 'Prämie ablehnen';

  @override
  String moderatorRejectBountyBody(String title) {
    return 'Prämie „$title” ablehnen?';
  }

  @override
  String get moderatorBountyApproved => 'Prämie freigegeben und öffentlich.';

  @override
  String get moderatorBountyRejected => 'Prämie abgelehnt.';

  @override
  String get moderatorObsPublish => 'Veröffentlichen';

  @override
  String get moderatorObsReject => 'Entfernen';

  @override
  String get moderatorObsPublished => 'Beobachtung veröffentlicht.';

  @override
  String get moderatorObsRejected => 'Beobachtung abgelehnt.';

  @override
  String get moderatorReportReason => 'Meldegrund';

  @override
  String get moderatorNoReason => 'nicht angegeben';

  @override
  String homeGreeting(String email) {
    return 'Hallo, $email!';
  }

  @override
  String get homeNewObservation => 'Neue Beobachtung';

  @override
  String get homeMyObservations => 'Meine Beobachtungen';

  @override
  String get homeMap => 'Karte';

  @override
  String get homeLogout => 'Abmelden';

  @override
  String get cameraTitle => 'Neue Beobachtung';

  @override
  String get cameraNoCamera => 'Auf diesem Gerät wurde keine Kamera gefunden.';

  @override
  String cameraInitFailed(String error) {
    return 'Die Kamera konnte nicht gestartet werden: $error';
  }

  @override
  String get cameraRetry => 'Erneut versuchen';

  @override
  String get cameraSaved => 'Beobachtung gespeichert!';

  @override
  String cameraError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get locationServiceDisabled =>
      'Die Ortungsdienste sind ausgeschaltet. Aktiviere sie unter Einstellungen → Datenschutz → Ortungsdienste.';

  @override
  String get locationPermissionDenied =>
      'Du hast die Standortberechtigung verweigert.';

  @override
  String get locationPermissionDeniedForever =>
      'Der Standortzugriff ist dauerhaft gesperrt. Einstellungen → BioSpotter → Standort.';

  @override
  String get locationUnavailable =>
      'Dein Standort konnte nicht bestimmt werden. Geh nach draußen oder warte ein paar Sekunden und versuche es erneut.';

  @override
  String get observationsTitle => 'Meine Beobachtungen';

  @override
  String get observationsEmpty => 'Du hast noch keine Beobachtungen';

  @override
  String get observationsUnknownSpecies => 'Unbestimmte Art';

  @override
  String observationsError(String error) {
    return 'Fehler: $error';
  }

  @override
  String observationsGps(String lat, String lng) {
    return 'GPS: $lat, $lng';
  }

  @override
  String observationsDateTime(String date) {
    return 'Zeitpunkt: $date';
  }

  @override
  String get searchTitle => 'Art suchen';

  @override
  String get searchHint => 'Artnamen eingeben...';

  @override
  String get searchStartHint =>
      'Beginne zu tippen, um eine Art zu suchen.\nDu kannst einen wissenschaftlichen oder Trivialnamen eingeben.';

  @override
  String get searchNoResults => 'Keine Treffer';

  @override
  String get searchTryOtherLanguage =>
      'Versuche eine andere Sprache oder gib den wissenschaftlichen Namen ein.';

  @override
  String get searchLanguage => 'Sprache:';

  @override
  String get searchFieldHint => 'Nach Artname suchen...';

  @override
  String get searchClear => 'Filter löschen';

  @override
  String searchResultCount(int count) {
    return '$count Treffer';
  }

  @override
  String get searchGroupPlants => 'Pflanzen';

  @override
  String get searchGroupAnimals => 'Tiere';

  @override
  String get searchGroupInsects => 'Insekten';

  @override
  String get searchGroupFungi => 'Pilze';

  @override
  String get searchIdentified => 'Bestimmt';

  @override
  String get searchUnidentified => 'Unbestimmt';

  @override
  String get searchFromDate => 'Von';

  @override
  String get searchToDate => 'Bis';

  @override
  String get searchTabMine => 'Meine';

  @override
  String get searchTabCommunity => 'Gemeinschaft';

  @override
  String get searchCommunityEmpty =>
      'Keine Gemeinschaftsbeobachtungen passen zu den Filtern.';

  @override
  String get searchCommunityLoad => 'Gemeinschaftsdaten laden';

  @override
  String get premiumTitle => 'Premium-Abo';

  @override
  String get premiumSubtitle =>
      'Für die Gemeinschaftsbeobachtungen ist ein Abo erforderlich.';

  @override
  String get premiumFeature1 => 'Beobachtungen aller Nutzer';

  @override
  String get premiumFeature2 => 'Suche nach Gebiet';

  @override
  String get premiumFeature3 => 'Artenliste der ganzen Region';

  @override
  String get premiumPrice => '3 € / Monat';

  @override
  String get premiumSubscribe => 'Abonnieren';

  @override
  String get premiumTestNote => 'Entwicklermodus — vorerst ohne Bezahlung.';

  @override
  String get premiumTestTitle => 'Premium aktivieren?';

  @override
  String get premiumTestBody =>
      'Dies ist ein Entwicklertest: Der Premium-Plan wird ohne Bezahlung aktiviert.';

  @override
  String get premiumActivated => 'Premium aktiviert (Test).';

  @override
  String get premiumActive => 'Premium-Abo aktiv';

  @override
  String get premiumDeactivate => 'Zurück auf Free (Test)';

  @override
  String get premiumDeactivated => 'Auf Free zurückgesetzt.';

  @override
  String get zoneNone => 'Kein Gebietsfilter';

  @override
  String get zoneHere => 'Gebiet: mein Standort';

  @override
  String get zoneClear => 'Gebiet löschen';

  @override
  String zoneActive(int km) {
    return 'Gebiet: innerhalb $km km';
  }

  @override
  String get zoneNoPermission =>
      'Der Gebietsfilter benötigt Standortberechtigung.';

  @override
  String get zoneFailed => 'Standort konnte nicht bestimmt werden.';

  @override
  String get deleteAccountTitle => 'Konto löschen';

  @override
  String get deleteAccountHeading => 'Möchtest du dein Konto wirklich löschen?';

  @override
  String get deleteAccountBody1 =>
      'Dein Name und deine E-Mail-Adresse werden entfernt und durch eine zufällige Kennung ersetzt. Du kannst dich später mit derselben Adresse erneut registrieren.';

  @override
  String get deleteAccountBody2 =>
      'Deine Beobachtungen bleiben anonym erhalten: Art, Ort und Datum bleiben, können aber nicht mehr mit dir verknüpft werden. Wenn du das nicht möchtest, lösche zuerst die Beobachtungen, die du nicht hinterlassen willst.';

  @override
  String get deleteAccountOpenMine => 'Meine Beobachtungen öffnen';

  @override
  String get deleteAccountConfirm =>
      'Ich bestätige, dass ich mein Konto löschen möchte';

  @override
  String get deleteAccountCancel => 'Abbrechen';

  @override
  String get deleteAccountButton => 'Konto löschen';

  @override
  String get deleteAccountDone =>
      'Dein Konto wurde gelöscht. Du kannst dich mit deiner E-Mail-Adresse erneut registrieren.';

  @override
  String get deleteAccountFailed =>
      'Kontolöschung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get legalPrivacy => 'Datenschutzerklärung';

  @override
  String get legalTerms => 'Nutzungsbedingungen';

  @override
  String get legalDeletion => 'Datenlöschung';

  @override
  String get reportButton => 'Melden';

  @override
  String get reportTitle => 'Was möchtest du melden?';

  @override
  String get reportNotNature => 'Unpassender Inhalt';

  @override
  String get reportViolent => 'Gewaltdarstellung';

  @override
  String get reportAdult => 'Erwachseneninhalte';

  @override
  String get reportOther => 'Sonstiges';

  @override
  String get reportCancel => 'Abbrechen';

  @override
  String get reportSent => 'Danke, wir haben deine Meldung erhalten.';

  @override
  String get reportFailed => 'Die Meldung konnte nicht gesendet werden.';

  @override
  String get statusPending => 'Wartet auf Bestimmung — noch nicht öffentlich.';

  @override
  String get statusFlagged => 'Gemeldet — in Prüfung.';

  @override
  String get statusRejected => 'Abgelehnt.';

  @override
  String mapCommunityCount(int count) {
    return 'Gemeinschaft: $count';
  }

  @override
  String get mapCommunityToggle => 'Gemeinschaft';

  @override
  String get mapCommunityLocked => 'Premium';

  @override
  String get mapSearchHint => 'Nach Art suchen…';

  @override
  String get mapNoMatch => 'Keine Treffer für diese Suche.';

  @override
  String get searchKingdom => 'Reich';

  @override
  String get searchFamily => 'Familie';

  @override
  String get searchGbifKey => 'GBIF-Schlüssel';

  @override
  String get searchVernaculars => 'Namen in anderen Sprachen';

  @override
  String get searchChoose => 'Diese Art wählen';

  @override
  String get searchKingdomAnimalia => 'Tiere';

  @override
  String get searchKingdomPlantae => 'Pflanzen';

  @override
  String get searchKingdomFungi => 'Pilze';

  @override
  String get obsSetSpecies => 'Art angeben / ändern';

  @override
  String get obsReidentify => 'Neu bestimmen';

  @override
  String get obsDelete => 'Beobachtung löschen';

  @override
  String get obsDeleteConfirmTitle => 'Beobachtung löschen?';

  @override
  String get obsDeleteConfirmBody =>
      'Die Beobachtung und ihr Foto werden dauerhaft gelöscht.';

  @override
  String get obsDeleted => 'Beobachtung gelöscht.';

  @override
  String get obsSpeciesSaved => 'Artname gespeichert.';

  @override
  String get tapForFullSize => 'Tippen für volle Größe';

  @override
  String get confirmTitle => 'Beobachtung speichern?';

  @override
  String get confirmSave => 'Speichern';

  @override
  String get confirmDiscard => 'Verwerfen';

  @override
  String get identifyTitle => 'Was hast du fotografiert?';

  @override
  String get identifyManual => 'Keine davon — manuell suchen';

  @override
  String get identifyManualHint =>
      'Art in der Catalogue of Life-Datenbank suchen';

  @override
  String get identifySkip => 'Ich weiß nicht / überspringen';

  @override
  String get identifyNone => 'Konnte nicht identifiziert werden';

  @override
  String get mapTitle => 'Karte';

  @override
  String mapObservationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Beobachtungen',
      one: '1 Beobachtung',
      zero: 'Keine Beobachtungen',
    );
    return '$_temp0';
  }

  @override
  String get mapEmpty =>
      'Du hast noch keine Beobachtungen. Mach eine, und sie erscheint hier auf der Karte.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsSystemLanguage => 'Systemsprache';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get navHome => 'Start';

  @override
  String get navMap => 'Karte';

  @override
  String get navCamera => 'Kamera';

  @override
  String get navObservations => 'Beobachtungen';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeSubtitle => 'Entdecke und bestimme die Natur um dich herum';

  @override
  String get homeNewObservationHint => 'Fotografiere eine Art und bestimme sie';

  @override
  String get homeObservationsLabel => 'Beobachtungen';

  @override
  String get homeSpeciesLabel => 'Bestimmte Arten';

  @override
  String get homeRecent => 'Letzte Beobachtungen';

  @override
  String get homeGroups => 'Gruppen';

  @override
  String get homeGroupsHint => 'Communities beitreten und Sichtungen verfolgen';

  @override
  String get homeBounties => 'Prämien';

  @override
  String get homeBountiesHint => 'Suche seltene Arten und sammle Punkte';
}
