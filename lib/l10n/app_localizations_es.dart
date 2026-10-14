// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'BioSpotter';

  @override
  String get loginTitle => 'BioSpotter';

  @override
  String get loginEmail => 'Correo electrónico';

  @override
  String get loginPassword => 'Contraseña';

  @override
  String get loginDisplayName => 'Nombre visible';

  @override
  String get loginSignIn => 'Iniciar sesión';

  @override
  String get loginSignUp => 'Registrarse';

  @override
  String get loginSwitchToSignUp => '¿Aún no tienes cuenta? Regístrate';

  @override
  String get loginSwitchToSignIn => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get loginEmailRequired => 'Introduce tu correo electrónico';

  @override
  String get loginEmailInvalid => 'Correo electrónico no válido';

  @override
  String get loginPasswordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String loginError(String error) {
    return 'Se produjo un error: $error';
  }

  @override
  String homeGreeting(String email) {
    return '¡Hola, $email!';
  }

  @override
  String get homeNewObservation => 'Nueva observación';

  @override
  String get homeMyObservations => 'Mis observaciones';

  @override
  String get homeMap => 'Mapa';

  @override
  String get homeLogout => 'Cerrar sesión';

  @override
  String get cameraTitle => 'Nueva observación';

  @override
  String get cameraNoCamera =>
      'No se encontró ninguna cámara en este dispositivo.';

  @override
  String cameraInitFailed(String error) {
    return 'La cámara no pudo iniciarse: $error';
  }

  @override
  String get cameraRetry => 'Reintentar';

  @override
  String get cameraSaved => '¡Observación guardada!';

  @override
  String cameraError(String error) {
    return 'Error: $error';
  }

  @override
  String get locationServiceDisabled =>
      'Los servicios de ubicación están desactivados. Actívalos en Ajustes → Privacidad → Localización.';

  @override
  String get locationPermissionDenied =>
      'Has denegado el permiso de ubicación.';

  @override
  String get locationPermissionDeniedForever =>
      'El acceso a la ubicación está bloqueado permanentemente. Ajustes → BioSpotter → Ubicación.';

  @override
  String get locationUnavailable =>
      'No se pudo determinar tu ubicación. Sal al exterior o espera unos segundos e inténtalo de nuevo.';

  @override
  String get observationsTitle => 'Mis observaciones';

  @override
  String get observationsEmpty => 'Aún no tienes observaciones';

  @override
  String get observationsUnknownSpecies => 'Especie sin identificar';

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
    return 'Fecha: $date';
  }

  @override
  String get searchTitle => 'Buscar especie';

  @override
  String get searchHint => 'Escribe el nombre de una especie...';

  @override
  String get searchStartHint =>
      'Empieza a escribir para buscar una especie.\nPuedes introducir un nombre científico o común.';

  @override
  String get searchNoResults => 'Sin resultados';

  @override
  String get searchTryOtherLanguage =>
      'Prueba otro idioma o introduce el nombre científico.';

  @override
  String get searchLanguage => 'Idioma:';

  @override
  String get searchFieldHint => 'Buscar por nombre de especie...';

  @override
  String get searchClear => 'Borrar filtros';

  @override
  String searchResultCount(int count) {
    return '$count resultados';
  }

  @override
  String get searchGroupPlants => 'Plantas';

  @override
  String get searchGroupAnimals => 'Animales';

  @override
  String get searchGroupInsects => 'Insectos';

  @override
  String get searchGroupFungi => 'Hongos';

  @override
  String get searchIdentified => 'Identificado';

  @override
  String get searchUnidentified => 'No identificado';

  @override
  String get searchFromDate => 'Desde';

  @override
  String get searchToDate => 'Hasta';

  @override
  String get searchTabMine => 'Mías';

  @override
  String get searchTabCommunity => 'Comunidad';

  @override
  String get searchCommunityEmpty =>
      'Ninguna observación comunitaria coincide con los filtros.';

  @override
  String get searchCommunityLoad => 'Cargar datos de la comunidad';

  @override
  String get premiumTitle => 'Suscripción Premium';

  @override
  String get premiumSubtitle =>
      'Se requiere una suscripción para ver las observaciones comunitarias.';

  @override
  String get premiumFeature1 => 'Observaciones de todos';

  @override
  String get premiumFeature2 => 'Búsqueda por zona';

  @override
  String get premiumFeature3 => 'Lista de especies de toda la región';

  @override
  String get premiumPrice => '3 € / mes';

  @override
  String get premiumSubscribe => 'Suscribirse';

  @override
  String get premiumTestNote => 'Modo desarrollador — sin pago por ahora.';

  @override
  String get premiumTestTitle => '¿Activar Premium?';

  @override
  String get premiumTestBody =>
      'Esta es una prueba de desarrollo: el plan Premium se activa sin pago.';

  @override
  String get premiumActivated => 'Premium activado (prueba).';

  @override
  String get premiumActive => 'Suscripción Premium activa';

  @override
  String get premiumDeactivate => 'Restablecer a gratuito (prueba)';

  @override
  String get premiumDeactivated => 'Restablecido a gratuito.';

  @override
  String get zoneNone => 'Sin filtro de zona';

  @override
  String get zoneHere => 'Zona: mi ubicación actual';

  @override
  String get zoneClear => 'Borrar zona';

  @override
  String zoneActive(int km) {
    return 'Zona: dentro de $km km';
  }

  @override
  String get zoneNoPermission =>
      'El filtro de zona requiere permiso de ubicación.';

  @override
  String get zoneFailed => 'No se pudo determinar tu ubicación.';

  @override
  String get deleteAccountTitle => 'Eliminar cuenta';

  @override
  String get deleteAccountHeading => '¿Seguro que quieres eliminar tu cuenta?';

  @override
  String get deleteAccountBody1 =>
      'Tu nombre y tu correo electrónico se eliminarán y se sustituirán por un identificador aleatorio. Podrás registrarte de nuevo más tarde con la misma dirección.';

  @override
  String get deleteAccountBody2 =>
      'Tus observaciones permanecen en forma anónima: la especie, el lugar y la fecha se mantienen, pero ya no pueden vincularse a ti. Si no lo quieres, elimina antes las observaciones que no quieras dejar.';

  @override
  String get deleteAccountOpenMine => 'Abrir mis observaciones';

  @override
  String get deleteAccountConfirm => 'Confirmo que quiero eliminar mi cuenta';

  @override
  String get deleteAccountCancel => 'Cancelar';

  @override
  String get deleteAccountButton => 'Eliminar cuenta';

  @override
  String get deleteAccountDone =>
      'Tu cuenta ha sido eliminada. Puedes registrarte de nuevo con tu correo electrónico.';

  @override
  String get deleteAccountFailed =>
      'No se pudo eliminar la cuenta. Inténtalo de nuevo.';

  @override
  String get searchKingdom => 'Reino';

  @override
  String get searchFamily => 'Familia';

  @override
  String get searchGbifKey => 'Clave GBIF';

  @override
  String get searchVernaculars => 'Nombres en otros idiomas';

  @override
  String get searchChoose => 'Elegir esta especie';

  @override
  String get searchKingdomAnimalia => 'Animales';

  @override
  String get searchKingdomPlantae => 'Plantas';

  @override
  String get searchKingdomFungi => 'Hongos';

  @override
  String get obsSetSpecies => 'Definir / cambiar especie';

  @override
  String get obsReidentify => 'Reidentificar';

  @override
  String get obsDelete => 'Eliminar observación';

  @override
  String get obsDeleteConfirmTitle => '¿Eliminar esta observación?';

  @override
  String get obsDeleteConfirmBody =>
      'La observación y su foto se eliminarán permanentemente.';

  @override
  String get obsDeleted => 'Observación eliminada.';

  @override
  String get obsSpeciesSaved => 'Nombre de especie guardado.';

  @override
  String get tapForFullSize => 'Toca para tamaño completo';

  @override
  String get confirmTitle => '¿Guardar esta observación?';

  @override
  String get confirmSave => 'Guardar';

  @override
  String get confirmDiscard => 'Descartar';

  @override
  String get identifyTitle => '¿Qué has fotografiado?';

  @override
  String get identifyManual => 'Ninguna — búsqueda manual';

  @override
  String get identifyManualHint =>
      'Buscar especie en la base de datos Catalogue of Life';

  @override
  String get identifySkip => 'No lo sé / omitir';

  @override
  String get identifyNone => 'No se pudo identificar';

  @override
  String get mapTitle => 'Mapa';

  @override
  String mapObservationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count observaciones',
      one: '1 observación',
      zero: 'Sin observaciones',
    );
    return '$_temp0';
  }

  @override
  String get mapEmpty =>
      'Aún no tienes observaciones. Haz una y aparecerá aquí en el mapa.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsSystemLanguage => 'Idioma del sistema';
}
