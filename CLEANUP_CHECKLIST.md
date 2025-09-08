# Задача: Финальная очистка оставшегося мертвого кода

## 🎯 Цель
Удалить последние 6 элементов "мертвого" кода для полного завершения очистки кодовой базы.

## ⚡ БЫСТРЫЕ ИСПРАВЛЕНИЯ

### 1. Удалить оставшиеся неиспользуемые виджеты (5 минут)
```bash
# Удалить последние неиспользуемые файлы:
rm lib/features/calendar/presentation/day_cell.dart
rm lib/features/calendar/presentation/day_sheet.dart  
rm lib/features/projects/widgets/project_search.dart
rm lib/features/dashboard/widgets/weekly_header.dart
```

### 2. Очистить неиспользуемый провайдер (3 минуты)
**Файл:** `lib/features/projects/presentation/projects_page.dart`
```dart
// НАЙТИ И УДАЛИТЬ эту строку:
// final projectsLoadingProvider = StateProvider<bool>((ref) => false);
```

**Файл:** `lib/core/providers/index.dart`
```dart
// НАЙТИ И УДАЛИТЬ экспорт:
// export 'package:rehearsal_app/features/projects/presentation/projects_page.dart' show
//   projectsLoadingProvider;
```

### 3. Удалить providerRegistry (2 минуты)
**Файл:** `lib/core/providers/index.dart`
```dart
// НАЙТИ И УДАЛИТЬ весь блок:
// /// Registry of all providers for debugging and testing
// /// DO NOT USE IN PRODUCTION CODE - for development tools only
// const Map<String, String> providerRegistry = {
//   // ... весь блок удалить
// };
```

## ✅ ПРОВЕРКА ЗАВЕРШЕНИЯ

### Команды для финальной проверки:
```bash
# 1. Убедиться что файлы удалены:
ls lib/features/calendar/presentation/day_cell.dart 2>/dev/null || echo "✅ day_cell.dart удален"
ls lib/features/calendar/presentation/day_sheet.dart 2>/dev/null || echo "✅ day_sheet.dart удален"  
ls lib/features/projects/widgets/project_search.dart 2>/dev/null || echo "✅ project_search.dart удален"
ls lib/features/dashboard/widgets/weekly_header.dart 2>/dev/null || echo "✅ weekly_header.dart удален"

# 2. Проверить что провайдер удален:
grep -r "projectsLoadingProvider" lib/ || echo "✅ projectsLoadingProvider удален"

# 3. Проверить что registry удален:
grep -r "providerRegistry" lib/ || echo "✅ providerRegistry удален"

# 4. Финальная проверка компиляции:
flutter analyze
# Должно быть: "No issues found!"

# 5. Тест запуска:
flutter run --debug
# Должно запускаться без ошибок
```

## 🎉 ОЖИДАЕМЫЙ РЕЗУЛЬТАТ

После завершения:
- **Полностью чистая кодовая база** - нет "мертвого" кода
- **Уменьшение размера** проекта на ~30%
- **Упрощение навигации** по коду
- **Готовность к дизайн-системе** - чистая основа

## ⏰ ВРЕМЯ ВЫПОЛНЕНИЯ

**Общее время:** 10 минут  
1. Удаление файлов: 5 минут
2. Очистка провайдера: 3 минуты  
3. Удаление registry: 2 минуты

## 🚀 СЛЕДУЮЩИЙ ШАГ

После завершения этой очистки можно **сразу переходить к созданию дизайн-системы** с полностью чистой кодовой базой!

---

## 📋 Краткий чеклист для выполнения:

- [ ] `rm lib/features/calendar/presentation/day_cell.dart`
- [ ] `rm lib/features/calendar/presentation/day_sheet.dart`
- [ ] `rm lib/features/projects/widgets/project_search.dart`  
- [ ] `rm lib/features/dashboard/widgets/weekly_header.dart`
- [ ] Удалить `projectsLoadingProvider` из projects_page.dart
- [ ] Удалить экспорт `projectsLoadingProvider` из index.dart
- [ ] Удалить `providerRegistry` из index.dart
- [ ] `flutter analyze` - проверить отсутствие ошибок
- [ ] `flutter run` - проверить запуск приложения

**Результат:** 100% чистая кодовая база, готовая к дизайн-системе!