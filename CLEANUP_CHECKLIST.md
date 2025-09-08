# Задача для Claude Code: Очистка неиспользуемого кода

## 🎯 Цель
Удалить "мертвый" код, накопившийся в процессе рефакторинга, для улучшения поддерживаемости и производительности приложения.

## 🧹 ПЛАН ОЧИСТКИ

### ЗАДАЧА 1: Удалить неиспользуемые UI компоненты
**Приоритет:** ВЫСОКИЙ  
**Время:** 30 минут

#### 1.1 Удалить неиспользуемые виджеты
```bash
# УДАЛИТЬ следующие файлы:
rm lib/core/widgets/error_state.dart
rm lib/core/utils/responsive.dart
rm lib/core/animations/app_animations.dart

# УДАЛИТЬ настройки (если не планируете использовать):
rm lib/features/settings/presentation/language_menu.dart
rm lib/features/settings/presentation/settings_page.dart
# ИЛИ оставить для будущего использования
```

#### 1.2 Проверить импорты
```bash
# Найти и удалить мертвые импорты этих файлов:
grep -r "error_state.dart" lib/
grep -r "responsive.dart" lib/
grep -r "app_animations.dart" lib/
grep -r "language_menu.dart" lib/
grep -r "settings_page.dart" lib/
```

---

### ЗАДАЧА 2: Очистить SupabaseDataSource
**Приоритет:** СРЕДНИЙ  
**Время:** 15 минут  
**Файл:** `lib/data/datasources/supabase_datasource.dart`

#### Удалить неиспользуемые методы:
```dart
// УДАЛИТЬ эти методы полностью:

/// Hard delete operation (use with caution)
Future<void> hardDelete({
  required String table,
  required String id,
}) async {
  // ... весь метод удалить
}

/// Execute raw SQL query (use sparingly)
Future<List<Map<String, dynamic>>> rawQuery(String query) async {
  // ... весь метод удалить
}

/// Check if record exists
Future<bool> exists({
  required String table,
  required String id,
  bool excludeDeleted = true,
}) async {
  // ... весь метод удалить
}
```

#### Оставить только используемые методы:
```dart
class SupabaseDataSource {
  // ОСТАВИТЬ:
  SupabaseClient get client;
  void _logOperation();
  Future<List<Map<String, dynamic>>> select();
  Future<Map<String, dynamic>?> selectById();
  Future<Map<String, dynamic>> insert();
  Future<Map<String, dynamic>?> update();
  Future<void> softDelete();
  Future<Map<String, dynamic>> upsert();
  Future<int> count();
  User? get currentUser;
  String? get currentUserId;
}
```

---

### ЗАДАЧА 3: Решить судьбу CheckConflicts use case
**Приоритет:** НИЗКИЙ  
**Время:** 20 минут

#### Вариант A: Удалить (если не планируете использовать)
```bash
# УДАЛИТЬ файлы:
rm lib/domain/usecases/check_conflicts.dart
rm lib/domain/constants/time_constants.dart
rm test/domain/usecases/check_conflicts_test.dart
```

#### Вариант B: Интегрировать в RehearsalsRepository (рекомендуется)
```dart
// В lib/data/repositories/rehearsals_repository_impl.dart ДОБАВИТЬ:

/// Check for conflicts when creating/updating rehearsal
Future<List<Conflict>> checkConflicts({
  required String rehearsalId,
  required DateTime startsAt,
  required DateTime endsAt,
  required List<String> participantIds,
}) async {
  final conflicts = <Conflict>[];
  
  // Проверка пересечений с существующими репетициями
  for (final userId in participantIds) {
    final overlapping = await _dataSource.select(
      table: _tableName,
      filters: {
        // Найти пересекающиеся репетиции
      },
    );
    
    // Добавить конфликты в список
  }
  
  return conflicts;
}

/// Check if user is available for rehearsal time
Future<bool> isUserAvailableForRehearsal({
  required String userId,
  required DateTime startsAt,
  required DateTime endsAt,
}) async {
  // Проверить доступность пользователя через AvailabilityRepository
  // Интегрироваться с существующей логикой
}
```

---

### ЗАДАЧА 4: Решить судьбу модуля настроек
**Приоритет:** НИЗКИЙ  
**Время:** 15 минут

#### Вариант A: Удалить полностью
```bash
# Если настройки не нужны:
rm -rf lib/features/settings/
```

#### Вариант B: Создать базовую интеграцию (рекомендуется)
```dart
// В lib/core/navigation/app_shell.dart ДОБАВИТЬ настройки в навигацию:

NavigationDestination(
  icon: const Icon(Icons.settings_outlined),
  selectedIcon: const Icon(Icons.settings),
  label: context.l10n.settings,
),

// В IndexedStack ДОБАВИТЬ:
const SettingsPage(),

// СОЗДАТЬ простую заглушку lib/features/settings/presentation/settings_page.dart:
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Text('Settings coming soon...'),
      ),
    );
  }
}
```

---

### ЗАДАЧА 5: Обновить провайдеры и импорты
**Приоритет:** ВЫСОКИЙ  
**Время:** 20 минут

#### 5.1 Очистить lib/core/providers/index.dart
```dart
// УДАЛИТЬ экспорты удаленных файлов:
// export 'package:rehearsal_app/core/widgets/error_state.dart';
// export 'package:rehearsal_app/core/utils/responsive.dart';
// export 'package:rehearsal_app/core/animations/app_animations.dart';

// ОБНОВИТЬ комментарии и документацию
```

#### 5.2 Проверить все импорты
```bash
# Найти и исправить сломанные импорты:
flutter analyze

# Если есть ошибки импорта - исправить или удалить
```

---

### ЗАДАЧА 6: Финальная проверка
**Приоритет:** КРИТИЧЕСКИЙ  
**Время:** 15 минут

#### Проверки перед завершением:
```bash
# 1. Компиляция без ошибок
flutter analyze
# Должно быть: "No issues found!"

# 2. Сборка приложения
flutter build apk --debug
# Должна пройти успешно

# 3. Запуск приложения
flutter run --debug
# Должно запускаться без крашей

# 4. Поиск потенциальных проблем
grep -r "TODO" lib/
grep -r "FIXME" lib/
grep -r "XXX" lib/
```

---

## 📋 ДЕТАЛЬНЫЙ ПЛАН ДЕЙСТВИЙ

### Этап 1: Анализ зависимостей (5 минут)
```bash
# Проверить какие файлы действительно не используются:
grep -r "ErrorState" lib/ --exclude-dir=test
grep -r "Responsive" lib/ --exclude-dir=test  
grep -r "AppAnimations" lib/ --exclude-dir=test
grep -r "CheckConflicts" lib/ --exclude-dir=test
grep -r "LanguageMenu" lib/ --exclude-dir=test
grep -r "SettingsPage" lib/ --exclude-dir=test
```

### Этап 2: Удаление файлов (10 минут)
```bash
# Удалить определенно неиспользуемые файлы
rm lib/core/widgets/error_state.dart
rm lib/core/utils/responsive.dart  
rm lib/core/animations/app_animations.dart

# Решить что делать с settings и check_conflicts
```

### Этап 3: Очистка SupabaseDataSource (10 минут)
- Удалить `hardDelete`, `rawQuery`, `exists` методы
- Проверить что все оставшиеся методы используются

### Этап 4: Обновление провайдеров (10 минут)
- Удалить экспорты из `index.dart`
- Исправить сломанные импорты

### Этап 5: Тестирование (10 минут)
- `flutter analyze`
- `flutter run`
- Проверка основной функциональности

---

## ✅ КРИТЕРИИ ГОТОВНОСТИ

### Чистота кода:
- [✅] Нет неиспользуемых файлов и методов
- [✅] Все импорты корректны
- [✅] `flutter analyze` показывает "No issues found!"

### Функциональность:
- [✅] Приложение компилируется без ошибок
- [✅] Основная навигация работает
- [✅] Нет runtime крашей

### Архитектурная готовность:
- [✅] Data layer полностью функционален
- [✅] Кодовая база готова к добавлению новых функций
- [✅] Нет "мертвого" кода

---

## 🎯 ОЖИДАЕМЫЙ РЕЗУЛЬТАТ

После очистки:
- **Уменьшение размера** кодовой базы на ~15-20%
- **Улучшение производительности** сборки
- **Повышение поддерживаемости** - нет путаницы с неиспользуемым кодом
- **Готовность к дизайн-системе** - чистая основа для новых компонентов

## ⏰ ВРЕМЯ ВЫПОЛНЕНИЯ

**Общее время:** 2 часа  
**Критический путь:** Анализ → Удаление файлов → Очистка методов → Тестирование  

После завершения можно сразу переходить к созданию дизайн-системы с чистой кодовой базой!