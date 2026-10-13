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
