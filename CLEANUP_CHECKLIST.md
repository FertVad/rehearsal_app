# Задача: Устранение технического долга

## 🎯 Цель
Исправить все выявленные проблемы безопасности, архитектуры и качества кода перед переходом к дизайн-системе.

## 🚨 КРИТИЧЕСКИЕ ИСПРАВЛЕНИЯ

### ЗАДАЧА 1: Вынести Supabase credentials в переменные окружения
**Приоритет:** КРИТИЧЕСКИЙ (безопасность)  
**Время:** 20 минут

#### 1.1 Создать .env файлы
**Создать файл:** `.env` (в корне проекта)
```env
# Supabase Configuration
SUPABASE_URL=https://atinuvocevcitsezubqm.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0aW51dm9jZXZjaXRzZXp1YnFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY5OTg5NDYsImV4cCI6MjA3MjU3NDk0Nn0.oischXeF_8bYzEveuPkaWna-JQXooraskhOqZ1UjaDI

# Development/Production modes
FLUTTER_ENV=development
```

**Создать файл:** `.env.example` (для команды)
```env
# Supabase Configuration
SUPABASE_URL=your_supabase_url_here
SUPABASE_ANON_KEY=your_supabase_anon_key_here

# Development/Production modes
FLUTTER_ENV=development
```

#### 1.2 Обновить .gitignore
**Файл:** `.gitignore`
```gitignore
# Environment variables
.env
.env.local
.env.production

# ... остальные правила
```

#### 1.3 Добавить зависимость flutter_dotenv
**Файл:** `pubspec.yaml`
```yaml
dependencies:
  flutter:
    sdk: flutter
  # ... остальные зависимости
  flutter_dotenv: ^5.1.0

flutter:
  # ... остальная конфигурация
  assets:
    - .env
```

#### 1.4 Обновить SupabaseConfig
**Файл:** `lib/core/supabase/supabase_config.dart`
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // УДАЛИТЬ hardcoded значения:
  // static const String url = 'https://...';
  // static const String anonKey = 'eyJhbGciOiJ...';
  
  // ЗАМЕНИТЬ НА:
  static String get url {
    final envUrl = dotenv.env['SUPABASE_URL'];
    if (envUrl == null || envUrl.isEmpty) {
      throw Exception('SUPABASE_URL not found in environment variables');
    }
    return envUrl;
  }
  
  static String get anonKey {
    final envKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (envKey == null || envKey.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY not found in environment variables');
    }
    return envKey;
  }
  
  static Future<void> initialize() async {
    // Загружаем .env файл
    await dotenv.load(fileName: ".env");
    
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: dotenv.env['FLUTTER_ENV'] == 'development',
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
```

#### 1.5 Обновить main.dart
**Файл:** `lib/main.dart`
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Загрузить environment variables ПЕРЕД инициализацией Supabase
  await dotenv.load(fileName: ".env");
  
  // Остальная инициализация...
  await SupabaseConfig.initialize();
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

---

### ЗАДАЧА 2: Удалить deprecated `_createDefaultUser`
**Приоритет:** СРЕДНИЙ  
**Время:** 15 минут

#### Найти и удалить устаревший код
**Файл:** `lib/features/user/controller/user_controller.dart`
```dart
// НАЙТИ И УДАЛИТЬ:
// @deprecated
// User _createDefaultUser() {
//   // ... весь метод удалить
// }

// ТАКЖЕ удалить все вызовы этого метода:
// final defaultUser = _createDefaultUser(); // УДАЛИТЬ
```

#### Проверить зависимости
```bash
# Найти все использования deprecated метода:
grep -r "_createDefaultUser" lib/
grep -r "createDefaultUser" lib/

# Если найдены - заменить на правильную логику
```

---

### ЗАДАЧА 3: Исправить use_build_context_synchronously
**Приоритет:** СРЕДНИЙ  
**Время:** 10 минут

#### Найти проблемное место
**Файл:** `lib/features/user/presentation/user_profile_page.dart`
```dart
// НАЙТИ код типа:
// ignore: use_build_context_synchronously
// Navigator.of(context).pushReplacement(...);

// ЗАМЕНИТЬ НА правильную проверку:
if (mounted) {
  Navigator.of(context).pushReplacement(...);
}

// ИЛИ сохранить context до async операции:
void _handleSignOut() async {
  final navigator = Navigator.of(context);
  
  await authService.signOut();
  
  // Теперь безопасно использовать сохраненный navigator
  navigator.pushReplacement(...);
}
```

---

### ЗАДАЧА 4: Исправить документацию в provider index
**Приоритет:** НИЗКИЙ  
**Время:** 2 минуты

**Файл:** `lib/core/providers/index.dart`
```dart
// ТЕКУЩИЙ КОД (неправильный):
library;
/// - FutureProvider: for async computations (e.g., userProfileProvider)

// ИСПРАВИТЬ НА:
/// - FutureProvider: for async computations (e.g., userProfileProvider)
library;

// Документация должна быть ПЕРЕД library directive
```

---

### ЗАДАЧА 5: Исключить generated файлы из git
**Приоритет:** НИЗКИЙ  
**Время:** 5 минут

#### 5.1 Обновить .gitignore
**Файл:** `.gitignore`
```gitignore
# Generated localization files
lib/l10n/app_localizations*.dart
*.g.dart
*.freezed.dart

# Generated files
**/generated/
**/.generated/
```

#### 5.2 Удалить generated файлы из git
```bash
# Удалить из git tracking:
git rm --cached lib/l10n/app_localizations_en.dart
git rm --cached lib/l10n/app_localizations_ru.dart

# Файлы останутся локально, но не будут отслеживаться git
```

#### 5.3 Обновить README с инструкциями
**Файл:** `README.md`
```markdown
## Development Setup

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Generate localization files:
   ```bash
   flutter gen-l10n
   ```

3. Copy environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your Supabase credentials
   ```
```

---

## 📋 ПРОВЕРОЧНЫЙ СПИСОК

### После завершения всех задач:

#### Безопасность:
- [ ] Hardcoded credentials удалены из кода
- [ ] .env файл добавлен в .gitignore
- [ ] .env.example создан для команды
- [ ] Приложение работает с переменными окружения

#### Качество кода:
- [ ] Deprecated методы удалены
- [ ] `use_build_context_synchronously` исправлено
- [ ] Документация provider index корректна
- [ ] Generated файлы исключены из git

#### Функциональность:
- [ ] `flutter pub get` работает
- [ ] `flutter analyze` показывает 0 issues
- [ ] `flutter run` запускается без ошибок
- [ ] Supabase подключение работает

---

## 🚨 ВАЖНЫЕ КОМАНДЫ

### Проверка environment setup:
```bash
# 1. Добавить зависимость
flutter pub add flutter_dotenv

# 2. Проверить .env загружается
flutter run --debug

# 3. Проверить отсутствие hardcoded credentials
grep -r "atinuvocevcitsezubqm" lib/ || echo "✅ Hardcoded URLs удалены"
grep -r "eyJhbGciOiJ" lib/ || echo "✅ Hardcoded keys удалены"
```

### Проверка качества кода:
```bash
# Проверить deprecated код удален
grep -r "deprecated" lib/ --include="*.dart"

# Проверить use_build_context_synchronously исправлено  
grep -r "ignore.*use_build_context_synchronously" lib/

# Анализ кода
flutter analyze
```

---

## ⏰ ВРЕМЯ ВЫПОЛНЕНИЯ

**Общее время:** 1 час  
1. Environment variables: 20 мин
2. Deprecated code: 15 мин  
3. Context synchronously: 10 мин
4. Documentation: 2 мин
5. Generated files: 5 мин
6. Тестирование: 8 мин

## 🎯 РЕЗУЛЬТАТ

После завершения:
- ✅ **Production-ready безопасность** - нет hardcoded credentials
- ✅ **Чистая архитектура** - нет deprecated кода
- ✅ **Quality code** - нет lint warnings
- ✅ **Правильный git flow** - generated файлы исключены

**Готовность к дизайн-системе: 100%** 🎨