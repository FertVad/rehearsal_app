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
