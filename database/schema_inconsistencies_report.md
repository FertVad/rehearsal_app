# Анализ несогласованностей между кодом и схемой БД Supabase

## 🔍 Выявленные проблемы

### 1. **profiles** таблица ✅ **ИСПРАВЛЕНО**
- ❌ **Было**: Код ожидал `full_name`, `username`, `email`
- ✅ **Сейчас**: Использует `display_name` согласно реальной схеме
- **Реальные поля**: `id`, `user_id`, `display_name`, `avatar_url`, `timezone`, `bio`, `phone`, `metadata`

### 2. **availability** таблица ✅ **ИСПРАВЛЕНО**
- ❌ **Было**: `'availabilities'` (множественное число)
- ✅ **Сейчас**: `'availability'` (единственное число)
- ❌ **Было**: `date_utc` (int)
- ✅ **Сейчас**: `date` (DATE)
- ⚠️  **Проблема**: Код ожидает `intervals_json`, `note` - этих полей нет в схеме
- **Реальные поля**: `id`, `user_id`, `date`, `status`, `created_at`, `updated_at`

### 3. **rehearsals** таблица ✅ **ЧАСТИЧНО ИСПРАВЛЕНО**
- ❌ **Было**: `location`
- ✅ **Сейчас**: `venue`
- ❌ **Было**: `rehearsal_participants.profile_id`
- ✅ **Сейчас**: `rehearsal_participants.user_id`
- ⚠️  **Проблема**: Код не устанавливает обязательное поле `created_by UUID NOT NULL`
- ⚠️  **Проблема**: Код пытается установить `is_mandatory`, но этого поля нет в схеме

### 4. **projects** таблица ✅ **УЖЕ РАБОТАЕТ**
- Код корректно использует поля согласно схеме

## 🚨 Критичные проблемы для исправления

### A. **availability** - отсутствующие поля
Код ожидает:
- `intervals_json` - не существует в схеме
- `note` - не существует в схеме

**Решение**: Либо добавить поля в БД, либо убрать из кода.

### B. **rehearsals** - обязательное поле `created_by`
В схеме: `created_by UUID REFERENCES profiles(id) NOT NULL`
В коде: поле не устанавливается

**Решение**: Добавить `created_by` в create метод.

### C. **rehearsals** - несуществующее поле `is_mandatory`
Код пытается установить `is_mandatory: true`, но поля нет в схеме.

## ✅ Исправленные проблемы
1. ✅ **profiles.display_name** вместо full_name
2. ✅ **availability** table name (единственное число)
3. ✅ **availability.date** вместо date_utc
4. ✅ **rehearsals.venue** вместо location
5. ✅ **rehearsal_participants.user_id** вместо profile_id

## 📋 Рекомендации

1. **Добавить в availability table**:
   ```sql
   ALTER TABLE availability 
   ADD COLUMN intervals_json JSONB,
   ADD COLUMN note TEXT;
   ```

2. **Исправить rehearsals repository** - добавить `created_by`:
   ```dart
   'created_by': currentUserId, // получить из auth
   ```

3. **Убрать из rehearsals** - поле `is_mandatory` (не существует)

4. **Тестировать каждый repository** с реальными данными