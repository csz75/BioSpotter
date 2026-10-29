import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hu'),
    Locale('it'),
    Locale('pl')
  ];

  /// No description provided for @appTitle.
  ///
  /// In hu, this message translates to:
  /// **'BioSpotter'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In hu, this message translates to:
  /// **'BioSpotter'**
  String get loginTitle;

  /// No description provided for @loginTagline.
  ///
  /// In hu, this message translates to:
  /// **'Fedezd fel a természetet, egy fotóval'**
  String get loginTagline;

  /// No description provided for @loginEmail.
  ///
  /// In hu, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In hu, this message translates to:
  /// **'Jelszó'**
  String get loginPassword;

  /// No description provided for @loginDisplayName.
  ///
  /// In hu, this message translates to:
  /// **'Megjelenített név'**
  String get loginDisplayName;

  /// No description provided for @loginSignIn.
  ///
  /// In hu, this message translates to:
  /// **'Bejelentkezés'**
  String get loginSignIn;

  /// No description provided for @loginSignUp.
  ///
  /// In hu, this message translates to:
  /// **'Regisztráció'**
  String get loginSignUp;

  /// No description provided for @loginSwitchToSignUp.
  ///
  /// In hu, this message translates to:
  /// **'Nincs fiókod? Regisztrálj'**
  String get loginSwitchToSignUp;

  /// No description provided for @loginSwitchToSignIn.
  ///
  /// In hu, this message translates to:
  /// **'Van már fiókod? Jelentkezz be'**
  String get loginSwitchToSignIn;

  /// No description provided for @loginEmailRequired.
  ///
  /// In hu, this message translates to:
  /// **'Add meg az email címedet'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In hu, this message translates to:
  /// **'Érvénytelen email cím'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordTooShort.
  ///
  /// In hu, this message translates to:
  /// **'A jelszó legalább 6 karakter'**
  String get loginPasswordTooShort;

  /// No description provided for @loginEmailNotConfirmed.
  ///
  /// In hu, this message translates to:
  /// **'Erősítsd meg az e-mail-címed, majd próbáld újra.'**
  String get loginEmailNotConfirmed;

  /// No description provided for @loginError.
  ///
  /// In hu, this message translates to:
  /// **'Hiba történt: {error}'**
  String loginError(String error);

  /// No description provided for @verifyEmailTitle.
  ///
  /// In hu, this message translates to:
  /// **'E-mail megerősítése'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailHeading.
  ///
  /// In hu, this message translates to:
  /// **'Erősítsd meg az e-mail-címed'**
  String get verifyEmailHeading;

  /// No description provided for @verifyEmailBody.
  ///
  /// In hu, this message translates to:
  /// **'Elküldtük a megerősítő levelet ide: {email}. A levélben lévő linkre kattintva aktiválódik a fiókod.'**
  String verifyEmailBody(String email);

  /// No description provided for @verifyEmailResend.
  ///
  /// In hu, this message translates to:
  /// **'Levél újraküldése'**
  String get verifyEmailResend;

  /// No description provided for @verifyEmailResent.
  ///
  /// In hu, this message translates to:
  /// **'Elküldtük újra a megerősítő levelet.'**
  String get verifyEmailResent;

  /// No description provided for @verifyEmailBack.
  ///
  /// In hu, this message translates to:
  /// **'Vissza a belépéshez'**
  String get verifyEmailBack;

  /// No description provided for @verifyEmailImDone.
  ///
  /// In hu, this message translates to:
  /// **'Már megerősítettem'**
  String get verifyEmailImDone;

  /// No description provided for @verifyEmailNotYet.
  ///
  /// In hu, this message translates to:
  /// **'A fiók még nincs megerősítve. Nyisd meg a levélben lévő linket.'**
  String get verifyEmailNotYet;

  /// No description provided for @likeTooltip.
  ///
  /// In hu, this message translates to:
  /// **'Tetszik'**
  String get likeTooltip;

  /// No description provided for @likeCount.
  ///
  /// In hu, this message translates to:
  /// **'{count} kedvelés'**
  String likeCount(int count);

  /// No description provided for @likeFailed.
  ///
  /// In hu, this message translates to:
  /// **'A kedvelés nem sikerült.'**
  String get likeFailed;

  /// No description provided for @likeMineCount.
  ///
  /// In hu, this message translates to:
  /// **'{count} kedvelés érkezett a megfigyelésedre'**
  String likeMineCount(int count);

  /// No description provided for @likeMineNone.
  ///
  /// In hu, this message translates to:
  /// **'Még nincs kedvelés ezen a megfigyelésen'**
  String get likeMineNone;

  /// No description provided for @groupsTitle.
  ///
  /// In hu, this message translates to:
  /// **'Csoportok'**
  String get groupsTitle;

  /// No description provided for @groupsEmpty.
  ///
  /// In hu, this message translates to:
  /// **'Még nincs csoportod. Hozz létre egyet, vagy csatlakozz egy meghívó kóddal.'**
  String get groupsEmpty;

  /// No description provided for @groupsCreate.
  ///
  /// In hu, this message translates to:
  /// **'Új csoport'**
  String get groupsCreate;

  /// No description provided for @groupsJoin.
  ///
  /// In hu, this message translates to:
  /// **'Csatlakozás kóddal'**
  String get groupsJoin;

  /// No description provided for @groupsName.
  ///
  /// In hu, this message translates to:
  /// **'Csoport neve'**
  String get groupsName;

  /// No description provided for @groupsDescription.
  ///
  /// In hu, this message translates to:
  /// **'Leírás (opcionális)'**
  String get groupsDescription;

  /// No description provided for @groupsInviteCode.
  ///
  /// In hu, this message translates to:
  /// **'Meghívó kód'**
  String get groupsInviteCode;

  /// No description provided for @groupsCreateButton.
  ///
  /// In hu, this message translates to:
  /// **'Létrehozás'**
  String get groupsCreateButton;

  /// No description provided for @groupsJoinButton.
  ///
  /// In hu, this message translates to:
  /// **'Csatlakozás'**
  String get groupsJoinButton;

  /// No description provided for @groupsJoinHint.
  ///
  /// In hu, this message translates to:
  /// **'pl. 5B-4K7X'**
  String get groupsJoinHint;

  /// No description provided for @groupsInvalidCode.
  ///
  /// In hu, this message translates to:
  /// **'Érvénytelen meghívó kód.'**
  String get groupsInvalidCode;

  /// No description provided for @groupsJoined.
  ///
  /// In hu, this message translates to:
  /// **'Sikeresen csatlakoztál.'**
  String get groupsJoined;

  /// No description provided for @groupsCreated.
  ///
  /// In hu, this message translates to:
  /// **'Csoport létrehozva.'**
  String get groupsCreated;

  /// No description provided for @groupInviteCodeLabel.
  ///
  /// In hu, this message translates to:
  /// **'Meghívó kód'**
  String get groupInviteCodeLabel;

  /// No description provided for @groupCopyCode.
  ///
  /// In hu, this message translates to:
  /// **'Kód másolása'**
  String get groupCopyCode;

  /// No description provided for @groupCodeCopied.
  ///
  /// In hu, this message translates to:
  /// **'Kód a vágólapra másolva.'**
  String get groupCodeCopied;

  /// No description provided for @groupEmpty.
  ///
  /// In hu, this message translates to:
  /// **'Még nincs megfigyelés ebben a csoportban.'**
  String get groupEmpty;

  /// No description provided for @groupNone.
  ///
  /// In hu, this message translates to:
  /// **'Nyilvános (nincs csoport)'**
  String get groupNone;

  /// No description provided for @groupPickTitle.
  ///
  /// In hu, this message translates to:
  /// **'Hova kerüljön a megfigyelés?'**
  String get groupPickTitle;

  /// No description provided for @groupVisibilityTitle.
  ///
  /// In hu, this message translates to:
  /// **'Látszódjon nyilvánosan is?'**
  String get groupVisibilityTitle;

  /// No description provided for @groupVisibilityBody.
  ///
  /// In hu, this message translates to:
  /// **'Ha nyilvános, a megfigyelés a közösségi nézetben is megjelenik. Ha nem, csak a csoport tagjai látják.'**
  String get groupVisibilityBody;

  /// No description provided for @groupVisibilityPublic.
  ///
  /// In hu, this message translates to:
  /// **'Nyilvános is'**
  String get groupVisibilityPublic;

  /// No description provided for @groupVisibilityGroupOnly.
  ///
  /// In hu, this message translates to:
  /// **'Csak a csoport'**
  String get groupVisibilityGroupOnly;

  /// No description provided for @groupMembersTitle.
  ///
  /// In hu, this message translates to:
  /// **'Tagok'**
  String get groupMembersTitle;

  /// No description provided for @groupMemberOwner.
  ///
  /// In hu, this message translates to:
  /// **'Csoportgazda'**
  String get groupMemberOwner;

  /// No description provided for @groupRemoveMember.
  ///
  /// In hu, this message translates to:
  /// **'Tag eltávolítása'**
  String get groupRemoveMember;

  /// No description provided for @groupRemoveMemberBody.
  ///
  /// In hu, this message translates to:
  /// **'Biztosan eltávolítod {name} tagot a csoportból?'**
  String groupRemoveMemberBody(String name);

  /// No description provided for @groupMemberRemoved.
  ///
  /// In hu, this message translates to:
  /// **'Tag eltávolítva.'**
  String get groupMemberRemoved;

  /// No description provided for @groupLeave.
  ///
  /// In hu, this message translates to:
  /// **'Kilépés a csoportból'**
  String get groupLeave;

  /// No description provided for @groupLeaveBody.
  ///
  /// In hu, this message translates to:
  /// **'A megfigyeléseid megmaradnak a csoportban, de te többé nem látod őket.'**
  String get groupLeaveBody;

  /// No description provided for @groupArchive.
  ///
  /// In hu, this message translates to:
  /// **'Csoport archiválása'**
  String get groupArchive;

  /// No description provided for @groupArchiveBody.
  ///
  /// In hu, this message translates to:
  /// **'Az archivált csoportot senki nem látja többé. Biztos vagy benne?'**
  String get groupArchiveBody;

  /// No description provided for @groupArchived.
  ///
  /// In hu, this message translates to:
  /// **'Archiválva'**
  String get groupArchived;

  /// No description provided for @groupArchivedSection.
  ///
  /// In hu, this message translates to:
  /// **'Archivált csoportok'**
  String get groupArchivedSection;

  /// No description provided for @groupRestore.
  ///
  /// In hu, this message translates to:
  /// **'Visszaállítás'**
  String get groupRestore;

  /// No description provided for @groupRestored.
  ///
  /// In hu, this message translates to:
  /// **'A csoport visszaállítva.'**
  String get groupRestored;

  /// No description provided for @bountyTitle.
  ///
  /// In hu, this message translates to:
  /// **'Kitűzések'**
  String get bountyTitle;

  /// No description provided for @bountyTabOpen.
  ///
  /// In hu, this message translates to:
  /// **'Nyitott'**
  String get bountyTabOpen;

  /// No description provided for @bountyTabMine.
  ///
  /// In hu, this message translates to:
  /// **'Sajátjaim'**
  String get bountyTabMine;

  /// No description provided for @bountyCreate.
  ///
  /// In hu, this message translates to:
  /// **'Új kitűzés'**
  String get bountyCreate;

  /// No description provided for @bountyEmpty.
  ///
  /// In hu, this message translates to:
  /// **'Jelenleg nincs nyitott kitűzés.'**
  String get bountyEmpty;

  /// No description provided for @bountyMineEmpty.
  ///
  /// In hu, this message translates to:
  /// **'Még nincs saját kitűzésed.'**
  String get bountyMineEmpty;

  /// No description provided for @bountyPoints.
  ///
  /// In hu, this message translates to:
  /// **'pont'**
  String get bountyPoints;

  /// No description provided for @bountySlots.
  ///
  /// In hu, this message translates to:
  /// **'hely'**
  String get bountySlots;

  /// No description provided for @bountyDaysLeft.
  ///
  /// In hu, this message translates to:
  /// **'{days} nap'**
  String bountyDaysLeft(int days);

  /// No description provided for @bountyExpires.
  ///
  /// In hu, this message translates to:
  /// **'Lejár'**
  String get bountyExpires;

  /// No description provided for @bountyStatusPending.
  ///
  /// In hu, this message translates to:
  /// **'Moderátor jóváhagyására vár'**
  String get bountyStatusPending;

  /// No description provided for @bountyStatusPaid.
  ///
  /// In hu, this message translates to:
  /// **'Lezárva — a jutalom kifizetve'**
  String get bountyStatusPaid;

  /// No description provided for @bountyStatusExpired.
  ///
  /// In hu, this message translates to:
  /// **'Lejárt'**
  String get bountyStatusExpired;

  /// No description provided for @bountySubmit.
  ///
  /// In hu, this message translates to:
  /// **'Megfigyelést jelentek be'**
  String get bountySubmit;

  /// No description provided for @bountyMyClaims.
  ///
  /// In hu, this message translates to:
  /// **'A beküldéseim'**
  String get bountyMyClaims;

  /// No description provided for @bountyClaims.
  ///
  /// In hu, this message translates to:
  /// **'Beküldések'**
  String get bountyClaims;

  /// No description provided for @bountyNoClaims.
  ///
  /// In hu, this message translates to:
  /// **'Még nincs beküldés.'**
  String get bountyNoClaims;

  /// No description provided for @bountyNoEligible.
  ///
  /// In hu, this message translates to:
  /// **'Nincs olyan megfigyelésed, ami illik ehhez a kitűzéshez.'**
  String get bountyNoEligible;

  /// No description provided for @bountyPickObservation.
  ///
  /// In hu, this message translates to:
  /// **'Melyik megfigyelést küldöd be?'**
  String get bountyPickObservation;

  /// No description provided for @bountyClaimSent.
  ///
  /// In hu, this message translates to:
  /// **'A beküldést elküldtük.'**
  String get bountyClaimSent;

  /// No description provided for @bountyAccept.
  ///
  /// In hu, this message translates to:
  /// **'Elfogadás'**
  String get bountyAccept;

  /// No description provided for @bountyReject.
  ///
  /// In hu, this message translates to:
  /// **'Elutasítás'**
  String get bountyReject;

  /// No description provided for @bountyAccepted.
  ///
  /// In hu, this message translates to:
  /// **'Elfogadva — a pont jóváírva.'**
  String get bountyAccepted;

  /// No description provided for @bountyRejected.
  ///
  /// In hu, this message translates to:
  /// **'Elutasítva.'**
  String get bountyRejected;

  /// No description provided for @bountyClaimPending.
  ///
  /// In hu, this message translates to:
  /// **'Elbírálásra vár'**
  String get bountyClaimPending;

  /// No description provided for @bountyClaimAccepted.
  ///
  /// In hu, this message translates to:
  /// **'Elfogadva'**
  String get bountyClaimAccepted;

  /// No description provided for @bountyClaimRejected.
  ///
  /// In hu, this message translates to:
  /// **'Elutasítva'**
  String get bountyClaimRejected;

  /// No description provided for @bountyFieldTitle.
  ///
  /// In hu, this message translates to:
  /// **'Kitűzés címe'**
  String get bountyFieldTitle;

  /// No description provided for @bountyFieldDescription.
  ///
  /// In hu, this message translates to:
  /// **'Leírás (opcionális)'**
  String get bountyFieldDescription;

  /// No description provided for @bountyFieldPoints.
  ///
  /// In hu, this message translates to:
  /// **'Jutalom (pont)'**
  String get bountyFieldPoints;

  /// No description provided for @bountyFieldWinners.
  ///
  /// In hu, this message translates to:
  /// **'Nyertesek száma'**
  String get bountyFieldWinners;

  /// No description provided for @bountyPickSpecies.
  ///
  /// In hu, this message translates to:
  /// **'Faj kiválasztása (opcionális)'**
  String get bountyPickSpecies;

  /// No description provided for @bountyPickExpiry.
  ///
  /// In hu, this message translates to:
  /// **'Határidő kiválasztása'**
  String get bountyPickExpiry;

  /// No description provided for @bountyCreateButton.
  ///
  /// In hu, this message translates to:
  /// **'Kitűzés létrehozása'**
  String get bountyCreateButton;

  /// No description provided for @bountyCreated.
  ///
  /// In hu, this message translates to:
  /// **'A kitűzés létrejött — moderátor jóváhagyására vár.'**
  String get bountyCreated;

  /// No description provided for @bountyTitleRequired.
  ///
  /// In hu, this message translates to:
  /// **'A cím megadása kötelező.'**
  String get bountyTitleRequired;

  /// No description provided for @bountyPointsRequired.
  ///
  /// In hu, this message translates to:
  /// **'A jutalom több mint 0 pont kell legyen.'**
  String get bountyPointsRequired;

  /// No description provided for @bountyApprovalNote.
  ///
  /// In hu, this message translates to:
  /// **'A kitűzés moderátor jóváhagyása után válik nyilvánossá. Kitűzést csak prémium előfizetők hozhatnak létre.'**
  String get bountyApprovalNote;

  /// No description provided for @moderatorTitle.
  ///
  /// In hu, this message translates to:
  /// **'Moderátor'**
  String get moderatorTitle;

  /// No description provided for @moderatorSubtitle.
  ///
  /// In hu, this message translates to:
  /// **'Kitűzések és bejelentések kezelése'**
  String get moderatorSubtitle;

  /// No description provided for @moderatorTabBounties.
  ///
  /// In hu, this message translates to:
  /// **'Kitűzések'**
  String get moderatorTabBounties;

  /// No description provided for @moderatorTabReports.
  ///
  /// In hu, this message translates to:
  /// **'Bejelentések'**
  String get moderatorTabReports;

  /// No description provided for @moderatorNoBounties.
  ///
  /// In hu, this message translates to:
  /// **'Nincs jóváhagyásra váró kitűzés.'**
  String get moderatorNoBounties;

  /// No description provided for @moderatorNoReports.
  ///
  /// In hu, this message translates to:
  /// **'Nincs bejelentett megfigyelés.'**
  String get moderatorNoReports;

  /// No description provided for @moderatorApprove.
  ///
  /// In hu, this message translates to:
  /// **'Jóváhagyás'**
  String get moderatorApprove;

  /// No description provided for @moderatorReject.
  ///
  /// In hu, this message translates to:
  /// **'Elutasítás'**
  String get moderatorReject;

  /// No description provided for @moderatorRejectBounty.
  ///
  /// In hu, this message translates to:
  /// **'Kitűzés elutasítása'**
  String get moderatorRejectBounty;

  /// No description provided for @moderatorRejectBountyBody.
  ///
  /// In hu, this message translates to:
  /// **'Biztosan elutasítod a(z) „{title}” kitűzést?'**
  String moderatorRejectBountyBody(String title);

  /// No description provided for @moderatorBountyApproved.
  ///
  /// In hu, this message translates to:
  /// **'A kitűzés jóváhagyva és nyilvános.'**
  String get moderatorBountyApproved;

  /// No description provided for @moderatorBountyRejected.
  ///
  /// In hu, this message translates to:
  /// **'A kitűzés elutasítva.'**
  String get moderatorBountyRejected;

  /// No description provided for @moderatorObsPublish.
  ///
  /// In hu, this message translates to:
  /// **'Közzététel'**
  String get moderatorObsPublish;

  /// No description provided for @moderatorObsReject.
  ///
  /// In hu, this message translates to:
  /// **'Eltávolítás'**
  String get moderatorObsReject;

  /// No description provided for @moderatorObsPublished.
  ///
  /// In hu, this message translates to:
  /// **'A megfigyelés közzétéve.'**
  String get moderatorObsPublished;

  /// No description provided for @moderatorObsRejected.
  ///
  /// In hu, this message translates to:
  /// **'A megfigyelés elutasítva.'**
  String get moderatorObsRejected;

  /// No description provided for @moderatorReportReason.
  ///
  /// In hu, this message translates to:
  /// **'Bejelentés oka'**
  String get moderatorReportReason;

  /// No description provided for @moderatorNoReason.
  ///
  /// In hu, this message translates to:
  /// **'nincs megadva'**
  String get moderatorNoReason;

  /// No description provided for @homeGreeting.
  ///
  /// In hu, this message translates to:
  /// **'Üdv, {email}!'**
  String homeGreeting(String email);

  /// No description provided for @homeNewObservation.
  ///
  /// In hu, this message translates to:
  /// **'Új megfigyelés'**
  String get homeNewObservation;

  /// No description provided for @homeMyObservations.
  ///
  /// In hu, this message translates to:
  /// **'Megfigyeléseim'**
  String get homeMyObservations;

  /// No description provided for @homeMap.
  ///
  /// In hu, this message translates to:
  /// **'Térkép'**
  String get homeMap;

  /// No description provided for @homeLogout.
  ///
  /// In hu, this message translates to:
  /// **'Kijelentkezés'**
  String get homeLogout;

  /// No description provided for @cameraTitle.
  ///
  /// In hu, this message translates to:
  /// **'Új megfigyelés'**
  String get cameraTitle;

  /// No description provided for @cameraNoCamera.
  ///
  /// In hu, this message translates to:
  /// **'Nem található kamera az eszközön.'**
  String get cameraNoCamera;

  /// No description provided for @cameraInitFailed.
  ///
  /// In hu, this message translates to:
  /// **'A kamera nem indult el: {error}'**
  String cameraInitFailed(String error);

  /// No description provided for @cameraRetry.
  ///
  /// In hu, this message translates to:
  /// **'Újrapróbálkozás'**
  String get cameraRetry;

  /// No description provided for @cameraSaved.
  ///
  /// In hu, this message translates to:
  /// **'Megfigyelés elmentve!'**
  String get cameraSaved;

  /// No description provided for @cameraError.
  ///
  /// In hu, this message translates to:
  /// **'Hiba: {error}'**
  String cameraError(String error);

  /// No description provided for @locationServiceDisabled.
  ///
  /// In hu, this message translates to:
  /// **'A helymeghatározás ki van kapcsolva. Kapcsold be: Beállítások → Adatvédelem → Helymeghatározás.'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In hu, this message translates to:
  /// **'A helymeghatározás engedélyt megtagadtad.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In hu, this message translates to:
  /// **'A helymeghatározás véglegesen tiltva. Beállítások → BioSpotter → Helymeghatározás.'**
  String get locationPermissionDeniedForever;

  /// No description provided for @locationUnavailable.
  ///
  /// In hu, this message translates to:
  /// **'Nem sikerült helyzetet meghatározni. Menj ki a szabadba, vagy várj pár másodpercet, majd próbáld újra.'**
  String get locationUnavailable;

  /// No description provided for @observationsTitle.
  ///
  /// In hu, this message translates to:
  /// **'Megfigyeléseim'**
  String get observationsTitle;

  /// No description provided for @observationsEmpty.
  ///
  /// In hu, this message translates to:
  /// **'Még nincs megfigyelésed'**
  String get observationsEmpty;

  /// No description provided for @observationsUnknownSpecies.
  ///
  /// In hu, this message translates to:
  /// **'Azonosítatlan faj'**
  String get observationsUnknownSpecies;

  /// No description provided for @observationsError.
  ///
  /// In hu, this message translates to:
  /// **'Hiba: {error}'**
  String observationsError(String error);

  /// No description provided for @observationsGps.
  ///
  /// In hu, this message translates to:
  /// **'GPS: {lat}, {lng}'**
  String observationsGps(String lat, String lng);

  /// No description provided for @observationsDateTime.
  ///
  /// In hu, this message translates to:
  /// **'Időpont: {date}'**
  String observationsDateTime(String date);

  /// No description provided for @searchTitle.
  ///
  /// In hu, this message translates to:
  /// **'Faj keresése'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In hu, this message translates to:
  /// **'Írd be a faj nevét...'**
  String get searchHint;

  /// No description provided for @searchStartHint.
  ///
  /// In hu, this message translates to:
  /// **'Kezdj el gépelni a faj nevének kereséséhez.\nTudományos vagy népies nevet is beírhatsz.'**
  String get searchStartHint;

  /// No description provided for @searchNoResults.
  ///
  /// In hu, this message translates to:
  /// **'Nincs találat'**
  String get searchNoResults;

  /// No description provided for @searchTryOtherLanguage.
  ///
  /// In hu, this message translates to:
  /// **'Próbáld másik nyelven, vagy add meg a tudományos nevet.'**
  String get searchTryOtherLanguage;

  /// No description provided for @searchLanguage.
  ///
  /// In hu, this message translates to:
  /// **'Nyelv:'**
  String get searchLanguage;

  /// No description provided for @searchFieldHint.
  ///
  /// In hu, this message translates to:
  /// **'Keresés fajnév alapján...'**
  String get searchFieldHint;

  /// No description provided for @searchClear.
  ///
  /// In hu, this message translates to:
  /// **'Szűrők törlése'**
  String get searchClear;

  /// No description provided for @searchResultCount.
  ///
  /// In hu, this message translates to:
  /// **'{count} találat'**
  String searchResultCount(int count);

  /// No description provided for @searchGroupPlants.
  ///
  /// In hu, this message translates to:
  /// **'Növények'**
  String get searchGroupPlants;

  /// No description provided for @searchGroupAnimals.
  ///
  /// In hu, this message translates to:
  /// **'Állatok'**
  String get searchGroupAnimals;

  /// No description provided for @searchGroupInsects.
  ///
  /// In hu, this message translates to:
  /// **'Rovarok'**
  String get searchGroupInsects;

  /// No description provided for @searchGroupFungi.
  ///
  /// In hu, this message translates to:
  /// **'Gombák'**
  String get searchGroupFungi;

  /// No description provided for @searchIdentified.
  ///
  /// In hu, this message translates to:
  /// **'Azonosított'**
  String get searchIdentified;

  /// No description provided for @searchUnidentified.
  ///
  /// In hu, this message translates to:
  /// **'Azonosítatlan'**
  String get searchUnidentified;

  /// No description provided for @searchFromDate.
  ///
  /// In hu, this message translates to:
  /// **'Ettől'**
  String get searchFromDate;

  /// No description provided for @searchToDate.
  ///
  /// In hu, this message translates to:
  /// **'Eddig'**
  String get searchToDate;

  /// No description provided for @searchTabMine.
  ///
  /// In hu, this message translates to:
  /// **'Saját'**
  String get searchTabMine;

  /// No description provided for @searchTabCommunity.
  ///
  /// In hu, this message translates to:
  /// **'Közösségi'**
  String get searchTabCommunity;

  /// No description provided for @searchCommunityEmpty.
  ///
  /// In hu, this message translates to:
  /// **'Még nincs közösségi megfigyelés a szűrőkkel.'**
  String get searchCommunityEmpty;

  /// No description provided for @searchCommunityLoad.
  ///
  /// In hu, this message translates to:
  /// **'Közösségi adatok betöltése'**
  String get searchCommunityLoad;

  /// No description provided for @premiumTitle.
  ///
  /// In hu, this message translates to:
  /// **'Prémium előfizetés'**
  String get premiumTitle;

  /// No description provided for @premiumSubtitle.
  ///
  /// In hu, this message translates to:
  /// **'A közösségi megfigyelések megtekintéséhez előfizetés szükséges.'**
  String get premiumSubtitle;

  /// No description provided for @premiumFeature1.
  ///
  /// In hu, this message translates to:
  /// **'Mindenki megfigyelései'**
  String get premiumFeature1;

  /// No description provided for @premiumFeature2.
  ///
  /// In hu, this message translates to:
  /// **'Körzet szerinti keresés'**
  String get premiumFeature2;

  /// No description provided for @premiumFeature3.
  ///
  /// In hu, this message translates to:
  /// **'Fajlista az egész régióról'**
  String get premiumFeature3;

  /// No description provided for @premiumPrice.
  ///
  /// In hu, this message translates to:
  /// **'3 € / hó'**
  String get premiumPrice;

  /// No description provided for @premiumSubscribe.
  ///
  /// In hu, this message translates to:
  /// **'Előfizetek'**
  String get premiumSubscribe;

  /// No description provided for @premiumTestNote.
  ///
  /// In hu, this message translates to:
  /// **'Fejlesztői mód — egyelőre fizetés nélkül.'**
  String get premiumTestNote;

  /// No description provided for @premiumScreenTitle.
  ///
  /// In hu, this message translates to:
  /// **'Prémium előfizetés'**
  String get premiumScreenTitle;

  /// No description provided for @premiumTestTitle.
  ///
  /// In hu, this message translates to:
  /// **'Prémium bekapcsolása?'**
  String get premiumTestTitle;

  /// No description provided for @premiumTestBody.
  ///
  /// In hu, this message translates to:
  /// **'Ez egy fejlesztői teszt: a prémium csomag fizetés nélkül aktiválódik.'**
  String get premiumTestBody;

  /// No description provided for @premiumActivated.
  ///
  /// In hu, this message translates to:
  /// **'Prémium aktiválva (teszt).'**
  String get premiumActivated;

  /// No description provided for @premiumActive.
  ///
  /// In hu, this message translates to:
  /// **'Prémium előfizetés aktív'**
  String get premiumActive;

  /// No description provided for @premiumDeactivate.
  ///
  /// In hu, this message translates to:
  /// **'Visszaállítás ingyenesre (teszt)'**
  String get premiumDeactivate;

  /// No description provided for @premiumManage.
  ///
  /// In hu, this message translates to:
  /// **'Kezelés'**
  String get premiumManage;

  /// No description provided for @premiumDeactivated.
  ///
  /// In hu, this message translates to:
  /// **'Visszaállítva ingyenesre.'**
  String get premiumDeactivated;

  /// No description provided for @zoneNone.
  ///
  /// In hu, this message translates to:
  /// **'Nincs körzet-szűrő'**
  String get zoneNone;

  /// No description provided for @zoneHere.
  ///
  /// In hu, this message translates to:
  /// **'Körzet: a jelenlegi helyzetem'**
  String get zoneHere;

  /// No description provided for @zoneClear.
  ///
  /// In hu, this message translates to:
  /// **'Körzet törlése'**
  String get zoneClear;

  /// No description provided for @zoneActive.
  ///
  /// In hu, this message translates to:
  /// **'Körzet: {km} km-en belül'**
  String zoneActive(int km);

  /// No description provided for @zoneNoPermission.
  ///
  /// In hu, this message translates to:
  /// **'A körzet-szűrőhöz helymeghatározás-engedély kell.'**
  String get zoneNoPermission;

  /// No description provided for @zoneFailed.
  ///
  /// In hu, this message translates to:
  /// **'Nem sikerült meghatározni a helyzetet.'**
  String get zoneFailed;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In hu, this message translates to:
  /// **'Fiók törlése'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountHeading.
  ///
  /// In hu, this message translates to:
  /// **'Biztosan törlöd a fiókodat?'**
  String get deleteAccountHeading;

  /// No description provided for @deleteAccountBody1.
  ///
  /// In hu, this message translates to:
  /// **'A neved és az e-mail címed törlődik, és egy véletlen azonosítóra cserélődik. Ezzel a címmel később újra regisztrálhatsz.'**
  String get deleteAccountBody1;

  /// No description provided for @deleteAccountBody2.
  ///
  /// In hu, this message translates to:
  /// **'A megfigyeléseid anonim formában megmaradnak: a faj, a hely és a dátum bennmarad, de a személyedhez nem köthető. Ha ezt nem szeretnéd, előbb töröld kézzel azokat a megfigyeléseket, amelyeket nem akarsz itt hagyni.'**
  String get deleteAccountBody2;

  /// No description provided for @deleteAccountOpenMine.
  ///
  /// In hu, this message translates to:
  /// **'Megfigyeléseim megnyitása'**
  String get deleteAccountOpenMine;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In hu, this message translates to:
  /// **'Megerősítem, hogy törölni akarom a fiókomat'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountCancel.
  ///
  /// In hu, this message translates to:
  /// **'Mégsem'**
  String get deleteAccountCancel;

  /// No description provided for @deleteAccountButton.
  ///
  /// In hu, this message translates to:
  /// **'Fiók törlése'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountDone.
  ///
  /// In hu, this message translates to:
  /// **'A fiókod törölve. Az e-mail címeddel újra regisztrálhatsz.'**
  String get deleteAccountDone;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In hu, this message translates to:
  /// **'A fiók törlése nem sikerült. Próbáld újra.'**
  String get deleteAccountFailed;

  /// No description provided for @legalPrivacy.
  ///
  /// In hu, this message translates to:
  /// **'Adatvédelmi tájékoztató'**
  String get legalPrivacy;

  /// No description provided for @legalTerms.
  ///
  /// In hu, this message translates to:
  /// **'Felhasználási feltételek'**
  String get legalTerms;

  /// No description provided for @legalDeletion.
  ///
  /// In hu, this message translates to:
  /// **'Adattörlési tudnivalók'**
  String get legalDeletion;

  /// No description provided for @reportButton.
  ///
  /// In hu, this message translates to:
  /// **'Bejelentés'**
  String get reportButton;

  /// No description provided for @reportTitle.
  ///
  /// In hu, this message translates to:
  /// **'Mit jelentessz be?'**
  String get reportTitle;

  /// No description provided for @reportNotNature.
  ///
  /// In hu, this message translates to:
  /// **'Nem oda való tartalom'**
  String get reportNotNature;

  /// No description provided for @reportViolent.
  ///
  /// In hu, this message translates to:
  /// **'Erőszakos tartalom'**
  String get reportViolent;

  /// No description provided for @reportAdult.
  ///
  /// In hu, this message translates to:
  /// **'Felnőtt tartalom'**
  String get reportAdult;

  /// No description provided for @reportOther.
  ///
  /// In hu, this message translates to:
  /// **'Egyéb'**
  String get reportOther;

  /// No description provided for @reportCancel.
  ///
  /// In hu, this message translates to:
  /// **'Mégsem'**
  String get reportCancel;

  /// No description provided for @reportSent.
  ///
  /// In hu, this message translates to:
  /// **'Köszönjük, megkaptuk a bejelentést.'**
  String get reportSent;

  /// No description provided for @reportFailed.
  ///
  /// In hu, this message translates to:
  /// **'A bejelentés nem sikerült.'**
  String get reportFailed;

  /// No description provided for @statusPending.
  ///
  /// In hu, this message translates to:
  /// **'Azonosításra vár — még nem látszik a közösségben.'**
  String get statusPending;

  /// No description provided for @statusFlagged.
  ///
  /// In hu, this message translates to:
  /// **'Bejelentve — moderálás alatt.'**
  String get statusFlagged;

  /// No description provided for @statusRejected.
  ///
  /// In hu, this message translates to:
  /// **'Elutasítva.'**
  String get statusRejected;

  /// No description provided for @mapCommunityCount.
  ///
  /// In hu, this message translates to:
  /// **'Közösségi: {count}'**
  String mapCommunityCount(int count);

  /// No description provided for @mapCommunityToggle.
  ///
  /// In hu, this message translates to:
  /// **'Közösségi'**
  String get mapCommunityToggle;

  /// No description provided for @mapCommunityLocked.
  ///
  /// In hu, this message translates to:
  /// **'Prémium'**
  String get mapCommunityLocked;

  /// No description provided for @mapSearchHint.
  ///
  /// In hu, this message translates to:
  /// **'Keresés fajra…'**
  String get mapSearchHint;

  /// No description provided for @mapNoMatch.
  ///
  /// In hu, this message translates to:
  /// **'Nincs találat erre a keresésre.'**
  String get mapNoMatch;

  /// No description provided for @searchKingdom.
  ///
  /// In hu, this message translates to:
  /// **'Ország'**
  String get searchKingdom;

  /// No description provided for @searchFamily.
  ///
  /// In hu, this message translates to:
  /// **'Család'**
  String get searchFamily;

  /// No description provided for @searchGbifKey.
  ///
  /// In hu, this message translates to:
  /// **'GBIF azonosító'**
  String get searchGbifKey;

  /// No description provided for @searchVernaculars.
  ///
  /// In hu, this message translates to:
  /// **'Nevek más nyelveken'**
  String get searchVernaculars;

  /// No description provided for @searchChoose.
  ///
  /// In hu, this message translates to:
  /// **'Ezt a fajt választom'**
  String get searchChoose;

  /// No description provided for @searchKingdomAnimalia.
  ///
  /// In hu, this message translates to:
  /// **'Állatok'**
  String get searchKingdomAnimalia;

  /// No description provided for @searchKingdomPlantae.
  ///
  /// In hu, this message translates to:
  /// **'Növények'**
  String get searchKingdomPlantae;

  /// No description provided for @searchKingdomFungi.
  ///
  /// In hu, this message translates to:
  /// **'Gombák'**
  String get searchKingdomFungi;

  /// No description provided for @obsSetSpecies.
  ///
  /// In hu, this message translates to:
  /// **'Faj megadása / módosítása'**
  String get obsSetSpecies;

  /// No description provided for @obsReidentify.
  ///
  /// In hu, this message translates to:
  /// **'Újra-azonosítás'**
  String get obsReidentify;

  /// No description provided for @obsDelete.
  ///
  /// In hu, this message translates to:
  /// **'Megfigyelés törlése'**
  String get obsDelete;

  /// No description provided for @obsDeleteConfirmTitle.
  ///
  /// In hu, this message translates to:
  /// **'Biztosan törlöd?'**
  String get obsDeleteConfirmTitle;

  /// No description provided for @obsDeleteConfirmBody.
  ///
  /// In hu, this message translates to:
  /// **'A megfigyelés és a hozzá tartozó fotó véglegesen törlődik.'**
  String get obsDeleteConfirmBody;

  /// No description provided for @obsDeleted.
  ///
  /// In hu, this message translates to:
  /// **'Megfigyelés törölve.'**
  String get obsDeleted;

  /// No description provided for @obsSpeciesSaved.
  ///
  /// In hu, this message translates to:
  /// **'A faj neve mentve.'**
  String get obsSpeciesSaved;

  /// No description provided for @tapForFullSize.
  ///
  /// In hu, this message translates to:
  /// **'Koppints a teljes mérethez'**
  String get tapForFullSize;

  /// No description provided for @confirmTitle.
  ///
  /// In hu, this message translates to:
  /// **'Mentse a megfigyelést?'**
  String get confirmTitle;

  /// No description provided for @confirmSave.
  ///
  /// In hu, this message translates to:
  /// **'Mentés'**
  String get confirmSave;

  /// No description provided for @confirmDiscard.
  ///
  /// In hu, this message translates to:
  /// **'Elvetés'**
  String get confirmDiscard;

  /// No description provided for @identifyTitle.
  ///
  /// In hu, this message translates to:
  /// **'Mit fotóztál?'**
  String get identifyTitle;

  /// No description provided for @identifyManual.
  ///
  /// In hu, this message translates to:
  /// **'Egyik sem — kézi keresés'**
  String get identifyManual;

  /// No description provided for @identifyManualHint.
  ///
  /// In hu, this message translates to:
  /// **'Faj keresése a Catalogue of Life adatbázisban'**
  String get identifyManualHint;

  /// No description provided for @identifySkip.
  ///
  /// In hu, this message translates to:
  /// **'Nem tudom / kihagyom'**
  String get identifySkip;

  /// No description provided for @identifyNone.
  ///
  /// In hu, this message translates to:
  /// **'Nem sikerült azonosítani'**
  String get identifyNone;

  /// No description provided for @mapTitle.
  ///
  /// In hu, this message translates to:
  /// **'Térkép'**
  String get mapTitle;

  /// No description provided for @mapObservationCount.
  ///
  /// In hu, this message translates to:
  /// **'{count, plural, =0{Nincs megfigyelés} =1{1 megfigyelés} other{{count} megfigyelés}}'**
  String mapObservationCount(int count);

  /// No description provided for @mapEmpty.
  ///
  /// In hu, this message translates to:
  /// **'Még nincs megfigyelésed. Készíts egyet, és megjelenik itt a térképen.'**
  String get mapEmpty;

  /// No description provided for @settingsTitle.
  ///
  /// In hu, this message translates to:
  /// **'Beállítások'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In hu, this message translates to:
  /// **'Nyelv'**
  String get settingsLanguage;

  /// No description provided for @settingsSystemLanguage.
  ///
  /// In hu, this message translates to:
  /// **'Rendszer nyelve'**
  String get settingsSystemLanguage;

  /// No description provided for @settingsAppearance.
  ///
  /// In hu, this message translates to:
  /// **'Megjelenés'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In hu, this message translates to:
  /// **'Rendszer'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In hu, this message translates to:
  /// **'Világos'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In hu, this message translates to:
  /// **'Sötét'**
  String get settingsThemeDark;

  /// No description provided for @navHome.
  ///
  /// In hu, this message translates to:
  /// **'Kezdőlap'**
  String get navHome;

  /// No description provided for @navMap.
  ///
  /// In hu, this message translates to:
  /// **'Térkép'**
  String get navMap;

  /// No description provided for @navCamera.
  ///
  /// In hu, this message translates to:
  /// **'Kamera'**
  String get navCamera;

  /// No description provided for @navObservations.
  ///
  /// In hu, this message translates to:
  /// **'Megfigyelések'**
  String get navObservations;

  /// No description provided for @navProfile.
  ///
  /// In hu, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @homeSubtitle.
  ///
  /// In hu, this message translates to:
  /// **'Fedezd fel és azonosítsd a környezeted élővilágát'**
  String get homeSubtitle;

  /// No description provided for @homeNewObservationHint.
  ///
  /// In hu, this message translates to:
  /// **'Fotózz egy fajt, és azonosítsd'**
  String get homeNewObservationHint;

  /// No description provided for @homeObservationsLabel.
  ///
  /// In hu, this message translates to:
  /// **'Megfigyelés'**
  String get homeObservationsLabel;

  /// No description provided for @homeSpeciesLabel.
  ///
  /// In hu, this message translates to:
  /// **'Azonosított faj'**
  String get homeSpeciesLabel;

  /// No description provided for @homeRecent.
  ///
  /// In hu, this message translates to:
  /// **'Legutóbbi megfigyelések'**
  String get homeRecent;

  /// No description provided for @homeGroups.
  ///
  /// In hu, this message translates to:
  /// **'Csoportok'**
  String get homeGroups;

  /// No description provided for @homeGroupsHint.
  ///
  /// In hu, this message translates to:
  /// **'Csatlakozz közösségekhez, kövesd mások észleléseit'**
  String get homeGroupsHint;

  /// No description provided for @homeBounties.
  ///
  /// In hu, this message translates to:
  /// **'Kitűzések'**
  String get homeBounties;

  /// No description provided for @homeBountiesHint.
  ///
  /// In hu, this message translates to:
  /// **'Keress ritka fajokat, szerezz pontokat'**
  String get homeBountiesHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'hu',
        'it',
        'pl'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hu':
      return AppLocalizationsHu();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
