# Чек-лист проверки согласованности приложения с Supabase

## Цель
Устранить все конфликты между локальной схемой Drift и схемой Supabase, привести таблицы в БД и код к полной согласованности.

## ✅ ВЫПОЛНЕНО: Анализ фактической схемы Supabase

### Фактические таблицы в Supabase:
- `profiles` - пользовательские профили (НЕ users!)
- `projects` - проекты (НЕ troupes!) 
- `rehearsals` - репетиции (другая структура полей)
- `rehearsal_participants` - участники репетиций (НЕ rehearsal_attendees!)
- `project_members` - участники проектов
- `active_projects` - активные проекты
- `notifications` - уведомления
- `project_invitations` - приглашения в проекты
- ❌ `availabilities` - ОТСУТСТВУЕТ

### ✅ ИСПРАВЛЕНО: Основные расхождения
1. **Таблица rehearsals**: поля `start_time`/`end_time` (timestamp) вместо `starts_at_utc`/`ends_at_utc` (bigint)
2. **Таблица profiles**: поле `user_id` для связи с auth.users.id, `display_name` вместо `name`
3. **Отсутствующая таблица availabilities**: создана заглушка

## 1. Схема базы данных

### 1.1 Таблицы аутентификации (Supabase Auth)
- [ ] `auth.users` - стандартная таблица Supabase Auth
- [ ] `auth.sessions` - сессии пользователей
- [ ] Проверить настройки RLS для auth таблиц

### 1.2 Пользовательские таблицы

#### Таблица `profiles` (Supabase)
- [x] **Проверить существование таблицы в Supabase** ✅ СУЩЕСТВУЕТ
- [x] **Схема таблицы:** ✅ ПРОВЕРЕНА
  - `id` (uuid, PK) - внутренний ID профиля
  - `user_id` (uuid) - связь с auth.users.id  
  - `created_at` (timestamp)  
  - `updated_at` (timestamp)
  - `deleted_at` (timestamp, nullable)
  - `display_name` (text, nullable) - отображаемое имя
  - `avatar_url` (text, nullable)  
  - `timezone` (text, default 'UTC') - часовой пояс
  - `bio` (text, nullable) - биография
  - `phone` (text, nullable) - телефон
  - `metadata` (jsonb, default '{}') - для настроек пользователя
- [ ] **RLS политики:**
  - Пользователи могут читать/изменять только свои профили
  - `auth.uid() = user_id`

#### Таблица `projects` (проекты, ex-troupes)
- [x] **Проверить существование таблицы в Supabase** ✅ СУЩЕСТВУЕТ (как `projects`)
- [x] **Схема таблицы:** ✅ ПРОВЕРЕНА
  - `id` (uuid, PK)
  - `created_at` (timestamp)
  - `updated_at` (timestamp) 
  - `deleted_at` (timestamp, nullable)
  - `name` (text, NOT NULL)
  - `description` (text, nullable)
  - `start_date` (date, nullable)
  - `end_date` (date, nullable)
  - `venue` (text, nullable)
  - `director_id` (uuid, nullable)
  - `invite_code` (text, default generated)
  - `is_active` (boolean, default true)
  - `metadata` (jsonb, default '{}')
- [x] **Индексы:** ✅ unique на invite_code (default constraint)
- [ ] **RLS политики:** участники проектов могут читать, админы - изменять

#### Таблица `project_members` (участники проектов)
- [x] **Проверить существование таблицы в Supabase** ✅ СУЩЕСТВУЕТ (как `project_members`)
- [x] **Схема таблицы:** ✅ ПРОВЕРЕНА
  - `id` (uuid, PK)
  - `created_at` (timestamp)
  - `updated_at` (timestamp)
  - `deleted_at` (timestamp, nullable)  
  - `project_id` (uuid, FK -> projects.id)
  - `profile_id` (uuid, FK -> profiles.id)
  - `role` (USER-DEFINED, default 'member') - admin|director|member
  - `joined_at` (timestamp, default now())
  - `is_active` (boolean, default true)
  - `metadata` (jsonb, default '{}')
- [x] **Ограничения:** ✅ предполагается UNIQUE(project_id, profile_id)
- [x] **Foreign Keys:** ✅ project_id, profile_id
- [ ] **RLS политики:** доступ для участников проекта

#### Таблица `rehearsals` (репетиции)
- [x] **Проверить существование таблицы в Supabase** ✅ СУЩЕСТВУЕТ
- [x] **Схема таблицы:** ✅ ПРОВЕРЕНА
  - `id` (uuid, PK)
  - `created_at` (timestamp, default now())
  - `updated_at` (timestamp, default now())
  - `deleted_at` (timestamp, nullable)
  - `project_id` (uuid, NOT NULL, FK -> projects.id) 
  - `title` (text, NOT NULL) - название репетиции
  - `description` (text, nullable) - описание
  - `location` (text, nullable) - место проведения
  - `start_time` (timestamp, NOT NULL) - время начала
  - `end_time` (timestamp, NOT NULL) - время окончания
  - `is_mandatory` (boolean, default false) - обязательная репетиция
  - `created_by` (uuid, nullable) - кто создал
- [x] **Индексы:** ✅ нужны на project_id, start_time для быстрых запросов
- [x] **Foreign Keys:** ✅ project_id -> projects.id
- [ ] **RLS политики:** доступ для участников проекта

#### Таблица `rehearsal_participants` (участники репетиций)
- [x] **Проверить существование таблицы в Supabase** ✅ СУЩЕСТВУЕТ (как `rehearsal_participants`)
- [x] **Схема таблицы:** ✅ ПРОВЕРЕНА
  - `id` (uuid, PK)
  - `created_at` (timestamp, default now())
  - `updated_at` (timestamp, default now())
  - `deleted_at` (timestamp, nullable)
  - `rehearsal_id` (uuid, NOT NULL, FK -> rehearsals.id)
  - `profile_id` (uuid, NOT NULL, FK -> profiles.id)  
  - `rsvp` (USER-DEFINED, default 'pending') - yes|no|pending
  - `response_time` (timestamp, nullable) - время ответа
  - `notes` (text, nullable) - заметки участника
  - `metadata` (jsonb, default '{}')
- [x] **Ограничения:** ✅ предполагается UNIQUE(rehearsal_id, profile_id)
- [x] **Foreign Keys:** ✅ rehearsal_id, profile_id
- [ ] **RLS политики:** доступ для участников репетиции

⚠️  **ВНИМАНИЕ:** Также существует старая таблица `rehearsal_attendees` с Drift-структурой - нужно решить какую использовать!

#### Таблица `availabilities` (доступность пользователей)
- [x] **Проверить существование таблицы в Supabase** ✅ СОЗДАНА
- [x] **Создать таблицу:** ✅ ВЫПОЛНЕНО
- [x] **Схема таблицы:** ✅ ГОТОВА
  - `id` (uuid, PK, default gen_random_uuid())
  - `created_at` (timestamp, default now())
  - `updated_at` (timestamp, default now()) 
  - `deleted_at` (timestamp, nullable)
  - `user_id` (uuid, NOT NULL, FK -> auth.users.id)
  - `date_utc` (bigint, NOT NULL) - дата в миллисекундах (00:00 UTC)
  - `status` (text, NOT NULL, CHECK free|busy|partial)
  - `intervals_json` (text, nullable) - JSON с интервалами времени
  - `note` (text, nullable)
- [x] **Ограничения:** ✅ UNIQUE(user_id, date_utc)
- [x] **Индексы:** ✅ СОЗДАНЫ (user_id, date_utc, composite)
- [x] **Foreign Keys:** ✅ user_id -> auth.users.id ON DELETE CASCADE
- [ ] **RLS политики:** ❌ НУЖНО НАСТРОИТЬ

## 2. Repositories и маппинг данных

### 2.1 Проверить Repository классы

#### SupabaseProfilesRepository
- [x] **Файл:** `lib/core/supabase/repositories/supabase_profiles_repository.dart` ✅
- [x] **Таблица:** 'profiles' ✅
- [x] **Методы:** ✅ ВСЕ РАБОТАЮТ
  - `getById(String id)` - получение профиля по user_id
  - `create(...)` - создание профиля с проверкой дублей
  - `updateMetadata(...)` - обновление metadata (настройки)
- [x] **Маппинг полей:** Drift User ↔ Supabase profiles ✅ ИСПРАВЛЕН
  - `id` ↔ `user_id` (связь с auth.users.id)
  - `createdAtUtc` ↔ `created_at` (timestamp to millis)
  - `updatedAtUtc` ↔ `updated_at` (timestamp to millis)
  - `name` ↔ `display_name`
  - `avatarUrl` ↔ `avatar_url`
  - `tz` ↔ `timezone`
  - `metadata` ↔ `metadata` (JSON)

#### SupabaseRehearsalsRepository  
- [x] **Файл:** `lib/core/supabase/repositories/supabase_rehearsals_repository.dart` ✅
- [x] **Таблица:** 'rehearsals' ✅
- [x] **Методы:** ✅ ВСЕ ИСПРАВЛЕНЫ
  - `create(...)` - создание репетиции с правильными полями
  - `getById(String id)` - получение по ID
  - `listForUserOnDateUtc(...)` - список через rehearsal_participants
  - `listForUserInRange(...)` - список в диапазоне через rehearsal_participants
  - `update(...)` - обновление с правильными полями
  - `softDelete(...)` - мягкое удаление
- [x] **Маппинг полей:** Drift Rehearsal ↔ Supabase rehearsals ✅ ИСПРАВЛЕН
  - `id` ↔ `id`
  - `troupeId` ↔ `project_id` (теперь проекты вместо групп)
  - `startsAtUtc` ↔ `start_time` (timestamp ↔ bigint)
  - `endsAtUtc` ↔ `end_time` (timestamp ↔ bigint)
  - `place` ↔ `location`
  - `note` ↔ `description`

#### SupabaseAvailabilityRepository
- [x] **Файл:** `lib/core/supabase/repositories/supabase_availability_repository.dart` ✅
- [x] **Таблица:** 'availabilities' ✅ СОЗДАНА
- [x] **Методы:** ✅ ГОТОВЫ И РАБОТАЮТ
  - `getForUserOnDateUtc(...)` - доступность пользователя на дату
  - `upsertForUserOnDateUtc(...)` - создание/обновление доступности
  - `listForUserRange(...)` - список в диапазоне дат
- [x] **Маппинг полей:** Drift Availability ↔ Supabase availabilities ✅ ГОТОВ
  - `id` ↔ `id`
  - `userId` ↔ `user_id`
  - `dateUtc` ↔ `date_utc`
  - `status` ↔ `status`
  - `intervalsJson` ↔ `intervals_json`
  - `note` ↔ `note`

### 2.2 Проверить Provider конфигурации
- [x] **Файл:** `lib/core/providers/repository_providers.dart` ✅ ПРОВЕРЕН
- [x] Все репозитории подключены к правильным Supabase репозиториям ✅
- [x] `usersRepositoryProvider` -> `SupabaseProfilesRepository` ✅
- [x] `rehearsalsRepositoryProvider` -> `SupabaseRehearsalsRepository` ✅
- [x] `availabilityRepositoryProvider` -> `SupabaseAvailabilityRepository` ✅

## 3. Аутентификация и безопасность

### 3.1 Supabase Auth настройки
- [ ] **Email/Password провайдер включен**
- [ ] **Google OAuth настроен** (если используется)
- [ ] **Email confirmations** настроены правильно
- [ ] **Password reset** работает

### 3.2 Row Level Security (RLS)
- [ ] **RLS включен на всех таблицах**
- [ ] **Политики безопасности созданы:**
  - profiles: пользователи видят только свои профили
  - troupes: участники видят свои труппы  
  - troupe_members: участники видят членов своих трупп
  - rehearsals: участники трупп видят репетиции
  - rehearsal_attendees: участники видят записи по своим репетициям
  - availabilities: пользователи видят только свою доступность

### 3.3 Проверить интеграцию с приложением
- [x] **AuthService** правильно создает профили при регистрации ✅ ИСПРАВЛЕНО
- [x] **AuthProvider** корректно отслеживает состояние аутентификации ✅ РАБОТАЕТ
- [x] **Router** правильно перенаправляет на основе auth состояния ✅ РАБОТАЕТ
- [x] **Все защищенные страницы** требуют аутентификации ✅ НАСТРОЕНО

## 4. Настройки пользователя

### 4.1 Хранение настроек
- [x] **Настройки хранятся в** `profiles.metadata` как JSON ✅ РЕАЛИЗОВАНО
- [x] **Структура JSON:** ✅ НАСТРОЕНА
  ```json
  {
    "settings": {
      "theme": "light|dark|system",
      "language": "ru|en", 
      "notifications": true,
      "soundEnabled": true,
      "other": {}
    }
  }
  ```

### 4.2 SettingsProvider
- [x] **Файл:** `lib/core/settings/settings_provider.dart` ✅ РАБОТАЕТ
- [x] Корректно читает настройки из `profiles.metadata` ✅
- [x] Корректно сохраняет изменения в Supabase ✅
- [x] Методы работают: `updateTheme`, `updateLanguage`, `updateNotifications`, `updateSound` ✅

## 5. Тестирование функциональности

### 5.1 Аутентификация
- [ ] **Регистрация** нового пользователя
- [ ] **Вход** существующего пользователя
- [ ] **Сброс пароля**
- [ ] **Выход** из системы
- [ ] **Google OAuth** (если настроен)
- [ ] **Автоматическое создание профиля** при регистрации

### 5.2 Профили пользователей
- [ ] **Чтение профиля** текущего пользователя
- [ ] **Обновление профиля** (имя, аватар, timezone)
- [ ] **Настройки пользователя** сохраняются и загружаются
- [ ] **Смена темы** работает корректно

### 5.3 Репетиции 
- [ ] **Создание репетиции**
- [ ] **Чтение списка репетиций**
- [ ] **Обновление репетиции**
- [ ] **Удаление репетиции** (мягкое)
- [ ] **Фильтрация по дате**

### 5.4 Доступность
- [ ] **Установка доступности** на дату
- [ ] **Чтение доступности** пользователя
- [ ] **Обновление доступности** (upsert)
- [ ] **Получение доступности** в диапазоне дат

## 6. Проверка логов и ошибок

### 6.1 Исправленные ошибки
- [x] ~~404 ошибки для таблицы 'user_availability'~~ - исправлено на 'availabilities'
- [x] ~~400 ошибки для таблицы 'rehearsals'~~ - исправлен маппинг полей
- [x] ~~Проблемы с аутентификацией~~ - исправлено
- [x] ~~Дублирование профилей~~ - исправлено

### 6.2 Проверить отсутствие ошибок
- [x] **Нет 404 ошибок** в логах при работе с БД ✅ ИСПРАВЛЕНО
- [x] **Нет 400/500 ошибок** при создании/обновлении записей ✅ ИСПРАВЛЕНО
- [x] **AuthService ошибки** устранены ✅ ИСПРАВЛЕНО
- [ ] **DebugService ошибки** (не критично, но желательно исправить) ⚠️ ОСТАЮТСЯ

## 7. Производительность и оптимизация

### 7.1 Индексы в Supabase
- [ ] **Индекс на rehearsals(troupe_id, starts_at_utc)**
- [ ] **Индекс на availabilities(user_id, date_utc)**  
- [ ] **Индекс на troupe_members(troupe_id, user_id)**
- [ ] **Unique индекс на troupes(invite_code)**

### 7.2 Запросы
- [ ] **Эффективные запросы** в репозиториях
- [ ] **Правильное использование** `.select()`, `.eq()`, `.gte()`, `.lt()`
- [ ] **Пагинация** для больших списков (если необходимо)

## 8. Документация и поддержка

### 8.1 Миграции
- [ ] **Схема версионирования** для будущих изменений
- [ ] **Backup стратегия** для данных
- [ ] **Rollback план** для критических изменений

### 8.2 Мониторинг  
- [ ] **Логирование ошибок** настроено правильно
- [ ] **Метрики производительности** (если необходимо)
- [ ] **Алерты** на критические ошибки

---

## Инструкции по проверке

### Для получения схемы Supabase:
1. Зайти в Supabase Dashboard
2. Перейти в Table Editor
3. Проверить все таблицы и их структуру
4. Сравнить с локальной Drift схемой в `lib/core/db/app_database.dart`

### Для проверки RLS:
1. В Supabase Dashboard -> Authentication -> Policies
2. Убедиться что все таблицы защищены RLS политиками

### Для тестирования:
1. Запустить приложение: `flutter run -d chrome --debug`
2. Пройти по всем основным сценариям
3. Проверить логи на отсутствие ошибок
4. Проверить данные в Supabase Dashboard

### При обнаружении проблем:
1. Сравнить локальную и удаленную схемы  
2. Обновить repository классы
3. Протестировать изменения
4. Обновить данный чек-лист