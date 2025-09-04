import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal App'**
  String get appTitle;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome! This is the home screen.'**
  String get homeWelcome;

  /// No description provided for @homeAboutButton.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get homeAboutButton;

  /// No description provided for @homeCalendarButton.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get homeCalendarButton;

  /// No description provided for @homeAvailabilityButton.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get homeAvailabilityButton;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal App v0.1'**
  String get aboutVersion;

  /// No description provided for @availabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availabilityTitle;

  /// No description provided for @availabilityOpenDay.
  ///
  /// In en, this message translates to:
  /// **'Open Day'**
  String get availabilityOpenDay;

  /// No description provided for @availabilityError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get availabilityError;

  /// No description provided for @availabilityStatusFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get availabilityStatusFree;

  /// No description provided for @availabilityStatusBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get availabilityStatusBusy;

  /// No description provided for @availabilityStatusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get availabilityStatusPartial;

  /// No description provided for @availabilityAddInterval.
  ///
  /// In en, this message translates to:
  /// **'Add interval'**
  String get availabilityAddInterval;

  /// No description provided for @availabilityCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get availabilityCancel;

  /// No description provided for @availabilitySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get availabilitySave;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarTabMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendarTabMonth;

  /// No description provided for @calendarTabWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get calendarTabWeek;

  /// No description provided for @daySheetAvailabilityNone.
  ///
  /// In en, this message translates to:
  /// **'Availability: none'**
  String get daySheetAvailabilityNone;

  /// No description provided for @daySheetRehearsals0.
  ///
  /// In en, this message translates to:
  /// **'Rehearsals: 0'**
  String get daySheetRehearsals0;

  /// No description provided for @daySheetChangeAvailability.
  ///
  /// In en, this message translates to:
  /// **'Change availability'**
  String get daySheetChangeAvailability;

  /// No description provided for @daySheetNewRehearsal.
  ///
  /// In en, this message translates to:
  /// **'New rehearsal'**
  String get daySheetNewRehearsal;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get navAvailability;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @noProjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get noProjectsTitle;

  /// No description provided for @noProjectsDescription.
  ///
  /// In en, this message translates to:
  /// **'Join an existing project or create your own'**
  String get noProjectsDescription;

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create project'**
  String get createProject;

  /// No description provided for @joinProject.
  ///
  /// In en, this message translates to:
  /// **'Join project'**
  String get joinProject;

  /// No description provided for @rehearsalCreate.
  ///
  /// In en, this message translates to:
  /// **'New Rehearsal'**
  String get rehearsalCreate;

  /// No description provided for @rehearsalEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Rehearsal'**
  String get rehearsalEdit;

  /// No description provided for @rehearsalDetails.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal Details'**
  String get rehearsalDetails;

  /// No description provided for @rehearsalDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Rehearsal'**
  String get rehearsalDelete;

  /// No description provided for @rehearsalDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this rehearsal? This action cannot be undone.'**
  String get rehearsalDeleteConfirm;

  /// No description provided for @rehearsalNotFound.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal not found'**
  String get rehearsalNotFound;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTime;

  /// No description provided for @rehearsalDate.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal date'**
  String get rehearsalDate;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTime;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @rehearsalLocation.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal location'**
  String get rehearsalLocation;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Main studio, Room 101'**
  String get locationHint;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a location'**
  String get locationRequired;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional notes'**
  String get additionalNotes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Optional notes about this rehearsal...'**
  String get notesHint;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @endTimeError.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get endTimeError;

  /// No description provided for @noUserFound.
  ///
  /// In en, this message translates to:
  /// **'No user found'**
  String get noUserFound;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @timezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezone;

  /// No description provided for @timezoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., UTC, Europe/London, Asia/Jerusalem'**
  String get timezoneHint;

  /// No description provided for @localUser.
  ///
  /// In en, this message translates to:
  /// **'Local User'**
  String get localUser;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get dec;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @upcomingRehearsals.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Rehearsals'**
  String get upcomingRehearsals;

  /// No description provided for @addRehearsal.
  ///
  /// In en, this message translates to:
  /// **'Add rehearsal'**
  String get addRehearsal;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load rehearsals'**
  String get failedToLoad;

  /// No description provided for @noRehearsalsScheduled.
  ///
  /// In en, this message translates to:
  /// **'No rehearsals scheduled'**
  String get noRehearsalsScheduled;

  /// No description provided for @scheduleFirst.
  ///
  /// In en, this message translates to:
  /// **'Schedule your first rehearsal'**
  String get scheduleFirst;

  /// No description provided for @createRehearsal.
  ///
  /// In en, this message translates to:
  /// **'Create rehearsal'**
  String get createRehearsal;

  /// No description provided for @rehearsal.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal'**
  String get rehearsal;

  /// No description provided for @errorLoadingCalendar.
  ///
  /// In en, this message translates to:
  /// **'Error loading calendar'**
  String get errorLoadingCalendar;

  /// No description provided for @noRehearsalsScheduledDay.
  ///
  /// In en, this message translates to:
  /// **'No rehearsals scheduled'**
  String get noRehearsalsScheduledDay;

  /// No description provided for @addRehearsalButton.
  ///
  /// In en, this message translates to:
  /// **'Add Rehearsal'**
  String get addRehearsalButton;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
