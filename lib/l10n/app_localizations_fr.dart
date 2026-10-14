// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'BioSpotter';

  @override
  String get loginTitle => 'BioSpotter';

  @override
  String get loginEmail => 'E-mail';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginDisplayName => 'Nom affiché';

  @override
  String get loginSignIn => 'Se connecter';

  @override
  String get loginSignUp => 'S\'inscrire';

  @override
  String get loginSwitchToSignUp => 'Pas encore de compte ? Inscrivez-vous';

  @override
  String get loginSwitchToSignIn => 'Vous avez déjà un compte ? Connectez-vous';

  @override
  String get loginEmailRequired => 'Veuillez saisir votre adresse e-mail';

  @override
  String get loginEmailInvalid => 'Adresse e-mail invalide';

  @override
  String get loginPasswordTooShort =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String loginError(String error) {
    return 'Une erreur est survenue : $error';
  }

  @override
  String homeGreeting(String email) {
    return 'Bonjour, $email !';
  }

  @override
  String get homeNewObservation => 'Nouvelle observation';

  @override
  String get homeMyObservations => 'Mes observations';

  @override
  String get homeMap => 'Carte';

  @override
  String get homeLogout => 'Déconnexion';

  @override
  String get cameraTitle => 'Nouvelle observation';

  @override
  String get cameraNoCamera => 'Aucune caméra trouvée sur cet appareil.';

  @override
  String cameraInitFailed(String error) {
    return 'La caméra n\'a pas pu démarrer : $error';
  }

  @override
  String get cameraRetry => 'Réessayer';

  @override
  String get cameraSaved => 'Observation enregistrée !';

  @override
  String cameraError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get locationServiceDisabled =>
      'Les services de localisation sont désactivés. Activez-les dans Réglages → Confidentialité → Service de localisation.';

  @override
  String get locationPermissionDenied =>
      'Vous avez refusé l\'autorisation de localisation.';

  @override
  String get locationPermissionDeniedForever =>
      'L\'accès à la localisation est définitivement bloqué. Réglages → BioSpotter → Localisation.';

  @override
  String get locationUnavailable =>
      'Impossible de déterminer votre position. Sortez ou attendez quelques secondes, puis réessayez.';

  @override
  String get observationsTitle => 'Mes observations';

  @override
  String get observationsEmpty => 'Vous n\'avez pas encore d\'observations';

  @override
  String get observationsUnknownSpecies => 'Espèce non identifiée';

  @override
  String observationsError(String error) {
    return 'Erreur : $error';
  }

  @override
  String observationsGps(String lat, String lng) {
    return 'GPS : $lat, $lng';
  }

  @override
  String observationsDateTime(String date) {
    return 'Date : $date';
  }

  @override
  String get searchTitle => 'Rechercher une espèce';

  @override
  String get searchHint => 'Saisissez un nom d\'espèce...';

  @override
  String get searchStartHint =>
      'Commencez à taper pour rechercher une espèce.\nVous pouvez saisir un nom scientifique ou vernaculaire.';

  @override
  String get searchNoResults => 'Aucun résultat';

  @override
  String get searchTryOtherLanguage =>
      'Essayez une autre langue ou saisissez le nom scientifique.';

  @override
  String get searchLanguage => 'Langue :';

  @override
  String get searchFieldHint => 'Rechercher par nom d\'espèce...';

  @override
  String get searchClear => 'Effacer les filtres';

  @override
  String searchResultCount(int count) {
    return '$count résultats';
  }

  @override
  String get searchGroupPlants => 'Plantes';

  @override
  String get searchGroupAnimals => 'Animaux';

  @override
  String get searchGroupInsects => 'Insectes';

  @override
  String get searchGroupFungi => 'Champignons';

  @override
  String get searchIdentified => 'Identifié';

  @override
  String get searchUnidentified => 'Non identifié';

  @override
  String get searchFromDate => 'Du';

  @override
  String get searchToDate => 'Au';

  @override
  String get searchTabMine => 'Mes';

  @override
  String get searchTabCommunity => 'Communauté';

  @override
  String get searchCommunityEmpty =>
      'Aucune observation communautaire ne correspond aux filtres.';

  @override
  String get searchCommunityLoad => 'Charger les données communautaires';

  @override
  String get premiumTitle => 'Abonnement Premium';

  @override
  String get premiumSubtitle =>
      'Un abonnement est nécessaire pour voir les observations communautaires.';

  @override
  String get premiumFeature1 => 'Observations de tout le monde';

  @override
  String get premiumFeature2 => 'Recherche par zone';

  @override
  String get premiumFeature3 => 'Liste des espèces de toute la région';

  @override
  String get premiumPrice => '3 € / mois';

  @override
  String get premiumSubscribe => 'S\'abonner';

  @override
  String get premiumTestNote =>
      'Mode développeur — sans paiement pour l\'instant.';

  @override
  String get premiumTestTitle => 'Activer Premium ?';

  @override
  String get premiumTestBody =>
      'Ceci est un test développeur : le forfait Premium s\'active sans paiement.';

  @override
  String get premiumActivated => 'Premium activé (test).';

  @override
  String get premiumActive => 'Abonnement Premium actif';

  @override
  String get premiumDeactivate => 'Réinitialiser en gratuit (test)';

  @override
  String get premiumDeactivated => 'Réinitialisé en gratuit.';

  @override
  String get zoneNone => 'Aucun filtre de zone';

  @override
  String get zoneHere => 'Zone : ma position actuelle';

  @override
  String get zoneClear => 'Effacer la zone';

  @override
  String zoneActive(int km) {
    return 'Zone : dans $km km';
  }

  @override
  String get zoneNoPermission =>
      'Le filtre de zone nécessite l\'autorisation de localisation.';

  @override
  String get zoneFailed => 'Impossible de déterminer votre position.';

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get deleteAccountHeading => 'Veux-tu vraiment supprimer ton compte ?';

  @override
  String get deleteAccountBody1 =>
      'Ton nom et ton adresse e-mail seront supprimés et remplacés par un identifiant aléatoire. Tu pourras t\'inscrire à nouveau plus tard avec la même adresse.';

  @override
  String get deleteAccountBody2 =>
      'Tes observations restent sous forme anonyme : l\'espèce, le lieu et la date subsistent, mais ne peuvent plus t\'être reliés. Si tu ne le souhaites pas, supprime d\'abord les observations que tu ne veux pas laisser.';

  @override
  String get deleteAccountOpenMine => 'Ouvrir mes observations';

  @override
  String get deleteAccountConfirm => 'Je confirme vouloir supprimer mon compte';

  @override
  String get deleteAccountCancel => 'Annuler';

  @override
  String get deleteAccountButton => 'Supprimer le compte';

  @override
  String get deleteAccountDone =>
      'Ton compte a été supprimé. Tu peux t\'inscrire à nouveau avec ton adresse e-mail.';

  @override
  String get deleteAccountFailed =>
      'La suppression du compte a échoué. Réessaie.';

  @override
  String get legalPrivacy => 'Politique de confidentialité';

  @override
  String get legalTerms => 'Conditions d\'utilisation';

  @override
  String get legalDeletion => 'Suppression des données';

  @override
  String mapCommunityCount(int count) {
    return 'Communauté : $count';
  }

  @override
  String get mapCommunityToggle => 'Communauté';

  @override
  String get mapCommunityLocked => 'Premium';

  @override
  String get mapSearchHint => 'Rechercher par espèce…';

  @override
  String get mapNoMatch => 'Aucun résultat pour cette recherche.';

  @override
  String get searchKingdom => 'Règne';

  @override
  String get searchFamily => 'Famille';

  @override
  String get searchGbifKey => 'Clé GBIF';

  @override
  String get searchVernaculars => 'Noms dans d\'autres langues';

  @override
  String get searchChoose => 'Choisir cette espèce';

  @override
  String get searchKingdomAnimalia => 'Animaux';

  @override
  String get searchKingdomPlantae => 'Plantes';

  @override
  String get searchKingdomFungi => 'Champignons';

  @override
  String get obsSetSpecies => 'Définir / modifier l\'espèce';

  @override
  String get obsReidentify => 'Réidentifier';

  @override
  String get obsDelete => 'Supprimer l\'observation';

  @override
  String get obsDeleteConfirmTitle => 'Supprimer cette observation ?';

  @override
  String get obsDeleteConfirmBody =>
      'L\'observation et sa photo seront définitivement supprimées.';

  @override
  String get obsDeleted => 'Observation supprimée.';

  @override
  String get obsSpeciesSaved => 'Nom d\'espèce enregistré.';

  @override
  String get tapForFullSize => 'Touchez pour la taille réelle';

  @override
  String get confirmTitle => 'Enregistrer cette observation ?';

  @override
  String get confirmSave => 'Enregistrer';

  @override
  String get confirmDiscard => 'Rejeter';

  @override
  String get identifyTitle => 'Qu\'as-tu photographié ?';

  @override
  String get identifyManual => 'Aucune — recherche manuelle';

  @override
  String get identifyManualHint =>
      'Rechercher une espèce dans la base Catalogue of Life';

  @override
  String get identifySkip => 'Je ne sais pas / passer';

  @override
  String get identifyNone => 'Impossible d\'identifier';

  @override
  String get mapTitle => 'Carte';

  @override
  String mapObservationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count observations',
      one: '1 observation',
      zero: 'Aucune observation',
    );
    return '$_temp0';
  }

  @override
  String get mapEmpty =>
      'Vous n\'avez pas encore d\'observations. Faites-en une et elle apparaîtra ici sur la carte.';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsSystemLanguage => 'Langue du système';
}
