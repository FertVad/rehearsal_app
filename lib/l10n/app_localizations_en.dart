// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rehearsal App';

  @override
  String get homeWelcome => 'Welcome! This is the home screen.';

  @override
  String get homeAboutButton => 'About';

  @override
  String get homeCalendarButton => 'Calendar';

  @override
  String get homeAvailabilityButton => 'Availability';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutVersion => 'Rehearsal App v0.1';

  @override
  String get availabilityTitle => 'Availability';

  @override
  String get availabilityOpenDay => 'Open Day';

  @override
  String get availabilityError => 'Error';

  @override
  String get availabilityStatusFree => 'Free';

  @override
  String get availabilityStatusBusy => 'Busy';

  @override
  String get availabilityStatusPartial => 'Partial';

  @override
  String get availabilityAddInterval => 'Add interval';

  @override
  String get availabilityCancel => 'Cancel';

  @override
  String get availabilitySave => 'Save';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarTabMonth => 'Month';

  @override
  String get calendarTabWeek => 'Week';

  @override
  String get daySheetAvailabilityNone => 'Availability: none';

  @override
  String get daySheetRehearsals0 => 'Rehearsals: 0';

  @override
  String get daySheetChangeAvailability => 'Change availability';

  @override
  String get daySheetNewRehearsal => 'New rehearsal';


  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navAvailability => 'Availability';

  @override
  String get navProjects => 'Projects';

  @override
  String get noProjectsTitle => 'No projects yet';

  @override
  String get noProjectsDescription => 'You don\'t have any projects yet.';
}
