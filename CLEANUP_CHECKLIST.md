# Задача: Финальная очистка кодовой базы

## Цель
Устранить последние остатки неиспользуемого кода, конфигурационных файлов и зависимостей для создания минимальной оптимизированной кодовой базы.

## ЗАДАЧИ

### ЗАДАЧА 1: Очистить DevTools конфигурацию
**Приоритет:** НИЗКИЙ  
**Время:** 2 минуты

```bash
# Удалить пустой конфигурационный файл
rm devtools_options.yaml
```

---

### ЗАДАЧА 2: Убедиться что pump_app.dart удален
**Приоритет:** НИЗКИЙ  
**Время:** 2 минуты

```bash
# Проверить и удалить если существует
rm test/helpers/pump_app.dart 2>/dev/null || echo "Файл уже удален"

# Удалить пустую папку helpers
rmdir test/helpers/ 2>/dev/null || true
```

---

### ЗАДАЧА 3: Очистить заглушки в availability_page_test.dart
**Приоритет:** СРЕДНИЙ  
**Время:** 10 минут

**Файл:** `test/features/availability/presentation/availability_page_test.dart`

**Вариант A: Удалить нефункциональный тест**
```bash
rm test/features/availability/presentation/availability_page_test.dart
```

**Вариант B: Исправить тест**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/features/availability/presentation/availability_page.dart';

void main() {
  group('AvailabilityPage', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AvailabilityPage(),
        ),
      );
      
      expect(find.byType(AvailabilityPage), findsOneWidget);
    });
  });
}
```

---

### ЗАДАЧА 4: Удалить неиспользуемые методы репозиториев
**Приоритет:** СРЕДНИЙ  
**Время:** 15 минут

#### 4.1 Проверить использование методов
```bash
# Проверить использование каждого подозрительного метода
grep -r "searchByEmail" lib/ --exclude-dir=test
grep -r "getActiveUsersCount" lib/ --exclude-dir=test
grep -r "searchByName" lib/ --exclude-dir=test
grep -r "update.*Project" lib/ --exclude-dir=test
grep -r "delete.*Project" lib/ --exclude-dir=test
```

#### 4.2 Удалить неиспользуемые методы из UsersRepositoryImpl
**Файл:** `lib/data/repositories/users_repository_impl.dart`
```dart
// УДАЛИТЬ если не используются:
// Future<List<User>> searchByEmail(String email) async { ... }
// Future<int> getActiveUsersCount() async { ... }
```

**Файл:** `lib/domain/repositories/users_repository.dart`
```dart
// ТАКЖЕ удалить из интерфейса соответствующие методы
```

#### 4.3 Удалить неиспользуемые методы из ProjectsRepositoryImpl
**Файл:** `lib/data/repositories/projects_repository_impl.dart`
```dart
// УДАЛИТЬ если не используются:
// Future<void> update({...}) async { ... }
// Future<void> delete({...}) async { ... }
// Future<List<Project>> searchByName(String name) async { ... }
```

**Файл:** `lib/domain/repositories/projects_repository.dart`
```dart
// ТАКЖЕ удалить из интерфейса соответствующие методы
```

---

### ЗАДАЧА 5: Удалить неиспользуемые зависимости из pubspec.yaml
**Приоритет:** СРЕДНИЙ  
**Время:** 5 минут

#### 5.1 Проверить наличие аннотаций кодогенерации
```bash
# Найти аннотации freezed
grep -r "@freezed\|@Freezed" lib/

# Найти аннотации json_serializable
grep -r "@JsonSerializable\|@jsonSerializable" lib/

# Найти generated файлы
find lib/ -name "*.g.dart" -o -name "*.freezed.dart"
```

#### 5.2 Удалить неиспользуемые зависимости
**Файл:** `pubspec.yaml`
```yaml
dependencies:
  # УДАЛИТЬ эти строки если аннотации не найдены:
  # freezed_annotation: ^2.4.1
  # json_annotation: ^4.8.1

dev_dependencies:
  # УДАЛИТЬ эти строки если кодогенерация не используется:
  # build_runner: ^2.4.9
  # freezed: ^2.4.7
  # json_serializable: ^6.7.1
```

---

### ЗАДАЧА 6: Финальная валидация
**Приоритет:** КРИТИЧЕСКИЙ  
**Время:** 10 минут

```bash
# 1. Обновить зависимости после изменений
flutter pub get

# 2. Проверить отсутствие ошибок компиляции
flutter analyze

# 3. Проверить что тесты работают
flutter test

# 4. Проверить зависимости
flutter pub deps

# 5. Подсчитать итоговый размер кодовой базы
echo "Количество Dart файлов: $(find lib/ -name "*.dart" | wc -l)"
echo "Общее количество строк: $(find lib/ -name "*.dart" -exec wc -l {} + | tail -1)"

# 6. Найти потенциально неиспользуемые файлы
find lib/ -name "*.dart" -exec basename {} .dart \; | while read file; do
  if ! grep -r "$file" lib/ --include="*.dart" -q; then
    echo "Возможно неиспользуемый файл: $file"
  fi
done
```

## КРИТЕРИИ ГОТОВНОСТИ

### Конфигурация и тесты:
- [ ] devtools_options.yaml удален
- [ ] pump_app.dart удален
- [ ] availability_page_test.dart очищен от заглушек или удален

### Репозитории:
- [ ] Неиспользуемые методы удалены из UsersRepositoryImpl
- [ ] Неиспользуемые методы удалены из ProjectsRepositoryImpl
- [ ] Интерфейсы репозиториев обновлены

### Зависимости:
- [ ] Неиспользуемые зависимости удалены из pubspec.yaml
- [ ] flutter pub get работает без ошибок
- [ ] Размер зависимостей оптимизирован

### Валидация:
- [ ] flutter analyze показывает 0 issues
- [ ] flutter test проходит (если тесты остались)
- [ ] Проект компилируется без ошибок
- [ ] Подсчитан итоговый размер кодовой базы

## ОЖИДАЕМЫЙ РЕЗУЛЬТАТ

После выполнения всех задач:
- Минимальная оптимизированная кодовая база
- Отсутствие неиспользуемых зависимостей и методов
- Нет пустых конфигурационных файлов
- Только функциональный код без балласта

## ВРЕМЯ ВЫПОЛНЕНИЯ

**Общее время:** 44 минуты
1. DevTools конфигурация: 2 мин
2. Test helpers: 2 мин
3. Test заглушки: 10 мин
4. Методы репозиториев: 15 мин
5. Зависимости pubspec: 5 мин
6. Финальная валидация: 10 мин