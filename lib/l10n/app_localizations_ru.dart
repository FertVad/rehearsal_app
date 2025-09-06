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

  @override
  String get navDashboard => 'Главная';

  @override
  String get navCalendar => 'Календарь';

  @override
  String get navAvailability => 'Доступность';

  @override
  String get navProjects => 'Проекты';

  @override
  String get navProfile => 'Профиль';

  @override
  String get noProjectsTitle => 'Нет проектов';

  @override
  String get noProjectsDescription => 'Присоединитесь к существующему проекту или создайте свой';

  @override
  String get createProject => 'Создать проект';

  @override
  String get joinProject => 'Присоединиться';

  @override
  String get rehearsalCreate => 'Новая репетиция';

  @override
  String get rehearsalEdit => 'Редактировать репетицию';

  @override
  String get rehearsalDetails => 'Детали репетиции';

  @override
  String get rehearsalDelete => 'Удалить репетицию';

  @override
  String get rehearsalDeleteConfirm => 'Вы уверены, что хотите удалить эту репетицию? Это действие нельзя отменить.';

  @override
  String get rehearsalNotFound => 'Репетиция не найдена';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get retry => 'Повторить';

  @override
  String get dateTime => 'Дата и время';

  @override
  String get rehearsalDate => 'Дата репетиции';

  @override
  String get startTime => 'Время начала';

  @override
  String get endTime => 'Время окончания';

  @override
  String get location => 'Место';

  @override
  String get rehearsalLocation => 'Место репетиции';

  @override
  String get locationHint => 'например, Основная студия, Комната 101';

  @override
  String get locationRequired => 'Пожалуйста, введите место';

  @override
  String get notes => 'Заметки';

  @override
  String get additionalNotes => 'Дополнительные заметки';

  @override
  String get notesHint => 'Необязательные заметки об этой репетиции...';

  @override
  String get details => 'Подробности';

  @override
  String get endTimeError => 'Время окончания должно быть позже времени начала';

  @override
  String get noUserFound => 'Пользователь не найден';

  @override
  String get profileSettings => 'Настройки профиля';

  @override
  String get name => 'Имя';

  @override
  String get timezone => 'Часовой пояс';

  @override
  String get timezoneHint => 'например, UTC, Europe/London, Asia/Jerusalem';

  @override
  String get localUser => 'Локальный пользователь';

  @override
  String get january => 'Январь';

  @override
  String get february => 'Февраль';

  @override
  String get march => 'Март';

  @override
  String get april => 'Апрель';

  @override
  String get may => 'Май';

  @override
  String get june => 'Июнь';

  @override
  String get july => 'Июль';

  @override
  String get august => 'Август';

  @override
  String get september => 'Сентябрь';

  @override
  String get october => 'Октябрь';

  @override
  String get november => 'Ноябрь';

  @override
  String get december => 'Декабрь';

  @override
  String get jan => 'Янв';

  @override
  String get feb => 'Фев';

  @override
  String get mar => 'Мар';

  @override
  String get apr => 'Апр';

  @override
  String get jun => 'Июн';

  @override
  String get jul => 'Июл';

  @override
  String get aug => 'Авг';

  @override
  String get sep => 'Сен';

  @override
  String get oct => 'Окт';

  @override
  String get nov => 'Ноя';

  @override
  String get dec => 'Дек';

  @override
  String get today => 'Сегодня';

  @override
  String get tomorrow => 'Завтра';

  @override
  String get upcomingRehearsals => 'Предстоящие репетиции';

  @override
  String get addRehearsal => 'Добавить репетицию';

  @override
  String get error => 'Ошибка';

  @override
  String get failedToLoad => 'Не удалось загрузить репетиции';

  @override
  String get noRehearsalsScheduled => 'Репетиции не запланированы';

  @override
  String get scheduleFirst => 'Запланируйте первую репетицию';

  @override
  String get createRehearsal => 'Создать репетицию';

  @override
  String get rehearsal => 'Репетиция';

  @override
  String get errorLoadingCalendar => 'Ошибка загрузки календаря';

  @override
  String get noRehearsalsScheduledDay => 'Репетиции не запланированы';

  @override
  String get addRehearsalButton => 'Добавить репетицию';

  @override
  String get goodMorning => 'Доброе утро';

  @override
  String get goodAfternoon => 'Добрый день';

  @override
  String get goodEvening => 'Добрый вечер';

  @override
  String get readyForRehearsal => 'Готовы к репетиции?';

  @override
  String get projectAvailabilityTitle => 'Доступность проекта на этой неделе';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get newRehearsal => 'Новая репетиция';

  @override
  String get setAvailability => 'Установить доступность';

  @override
  String get mondayShort => 'Пн';

  @override
  String get tuesdayShort => 'Вт';

  @override
  String get wednesdayShort => 'Ср';

  @override
  String get thursdayShort => 'Чт';

  @override
  String get fridayShort => 'Пт';

  @override
  String get saturdayShort => 'Сб';

  @override
  String get sundayShort => 'Вс';

  @override
  String get signIn => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get displayName => 'Отображаемое имя';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get or => 'ИЛИ';

  @override
  String get continueWithGoogle => 'Продолжить с Google';

  @override
  String get pleaseEnterEmail => 'Пожалуйста, введите ваш email';

  @override
  String get pleaseEnterValidEmail => 'Пожалуйста, введите корректный email';

  @override
  String get pleaseEnterPassword => 'Пожалуйста, введите пароль';

  @override
  String get pleaseEnterDisplayName => 'Пожалуйста, введите отображаемое имя';

  @override
  String get passwordTooShort => 'Пароль должен содержать не менее 6 символов';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get pleaseEnterEmailForReset => 'Введите email для восстановления пароля';

  @override
  String get passwordResetEmailSent => 'Письмо для сброса пароля отправлено! Проверьте почту.';

  @override
  String get signOut => 'Выйти';

  @override
  String get signOutConfirmation => 'Вы уверены, что хотите выйти?';
}
