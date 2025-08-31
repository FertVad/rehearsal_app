// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Rehearsal App';

  @override
  String get homeWelcome => 'Добро пожаловать! Это стартовый экран.';

  @override
  String get homeAboutButton => 'О приложении';

  @override
  String get homeCalendarButton => 'Календарь';

  @override
  String get homeAvailabilityButton => 'Доступность';

  @override
  String get aboutTitle => 'О приложении';

  @override
  String get aboutVersion => 'Rehearsal App v0.1';

  @override
  String get availabilityTitle => 'Доступность';

  @override
  String get availabilityOpenDay => 'Открыть день';

  @override
  String get availabilityError => 'Ошибка';

  @override
  String get availabilityStatusFree => 'Свободен';

  @override
  String get availabilityStatusBusy => 'Занят';

  @override
  String get availabilityStatusPartial => 'Частично';

  @override
  String get availabilityAddInterval => 'Добавить интервал';

  @override
  String get availabilityCancel => 'Отмена';

  @override
  String get availabilitySave => 'Сохранить';

  @override
  String get calendarTitle => 'Календарь';

  @override
  String get calendarTabMonth => 'Месяц';

  @override
  String get calendarTabWeek => 'Неделя';

  @override
  String get daySheetAvailabilityNone => 'Доступность: нет';

  @override
  String get daySheetRehearsals0 => 'Репетиции: 0';

  @override
  String get daySheetChangeAvailability => 'Изменить доступность';

  @override
  String get daySheetNewRehearsal => 'Новая репетиция';
}
