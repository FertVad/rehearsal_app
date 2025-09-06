-- Создание индексов для оптимизации производительности
-- Выполните этот SQL в Supabase Dashboard -> SQL Editor

-- =============================================================================
-- 1. REHEARSALS TABLE - Индексы для быстрого поиска репетиций
-- =============================================================================

-- Индекс для поиска репетиций по проекту и времени начала
CREATE INDEX IF NOT EXISTS idx_rehearsals_project_start_time 
ON public.rehearsals (project_id, start_time);

-- Индекс для поиска репетиций по времени (для календарных запросов)
CREATE INDEX IF NOT EXISTS idx_rehearsals_start_time 
ON public.rehearsals (start_time);

-- Индекс для поиска репетиций по создателю
CREATE INDEX IF NOT EXISTS idx_rehearsals_created_by 
ON public.rehearsals (created_by);

-- =============================================================================
-- 2. REHEARSAL_PARTICIPANTS TABLE - Индексы для участников репетиций
-- =============================================================================

-- Индекс для поиска участников по репетиции
CREATE INDEX IF NOT EXISTS idx_rehearsal_participants_rehearsal_id 
ON public.rehearsal_participants (rehearsal_id);

-- Индекс для поиска репетиций пользователя
CREATE INDEX IF NOT EXISTS idx_rehearsal_participants_profile_id 
ON public.rehearsal_participants (profile_id);

-- Составной индекс для уникальности и быстрого поиска
CREATE INDEX IF NOT EXISTS idx_rehearsal_participants_rehearsal_profile 
ON public.rehearsal_participants (rehearsal_id, profile_id);

-- Индекс для поиска по статусу RSVP
CREATE INDEX IF NOT EXISTS idx_rehearsal_participants_rsvp 
ON public.rehearsal_participants (rsvp);

-- =============================================================================
-- 3. PROJECT_MEMBERS TABLE - Индексы для участников проектов
-- =============================================================================

-- Индекс для поиска участников проекта
CREATE INDEX IF NOT EXISTS idx_project_members_project_id 
ON public.project_members (project_id);

-- Индекс для поиска проектов пользователя
CREATE INDEX IF NOT EXISTS idx_project_members_profile_id 
ON public.project_members (profile_id);

-- Индекс для активных участников
CREATE INDEX IF NOT EXISTS idx_project_members_active 
ON public.project_members (is_active) WHERE is_active = true;

-- Индекс для поиска по роли
CREATE INDEX IF NOT EXISTS idx_project_members_role 
ON public.project_members (role);

-- =============================================================================
-- 4. PROJECTS TABLE - Индексы для проектов
-- =============================================================================

-- Индекс для активных проектов
CREATE INDEX IF NOT EXISTS idx_projects_active 
ON public.projects (is_active) WHERE is_active = true;

-- Индекс для поиска проектов по режиссеру
CREATE INDEX IF NOT EXISTS idx_projects_director_id 
ON public.projects (director_id);

-- Индекс для поиска по датам проекта
CREATE INDEX IF NOT EXISTS idx_projects_dates 
ON public.projects (start_date, end_date);

-- Индекс для поиска по коду приглашения
CREATE INDEX IF NOT EXISTS idx_projects_invite_code 
ON public.projects (invite_code) WHERE invite_code IS NOT NULL;

-- =============================================================================
-- 5. PROJECT_INVITATIONS TABLE - Индексы для приглашений
-- =============================================================================

-- Индекс для поиска приглашений по проекту
CREATE INDEX IF NOT EXISTS idx_project_invitations_project_id 
ON public.project_invitations (project_id);

-- Индекс для поиска приглашений пользователя
CREATE INDEX IF NOT EXISTS idx_project_invitations_invited_profile_id 
ON public.project_invitations (invited_profile_id);

-- Индекс для поиска по статусу приглашения
CREATE INDEX IF NOT EXISTS idx_project_invitations_status 
ON public.project_invitations (status);

-- Индекс для поиска по email
CREATE INDEX IF NOT EXISTS idx_project_invitations_email 
ON public.project_invitations (email);

-- Индекс для времени истечения приглашений (без предиката с now())
CREATE INDEX IF NOT EXISTS idx_project_invitations_expires_at 
ON public.project_invitations (expires_at);

-- Альтернатива: Функциональный индекс для проверки активности
CREATE INDEX IF NOT EXISTS idx_project_invitations_is_active 
ON public.project_invitations ((expires_at > CURRENT_TIMESTAMP));

-- =============================================================================
-- 6. NOTIFICATIONS TABLE - Индексы для уведомлений
-- =============================================================================

-- Индекс для поиска уведомлений пользователя
CREATE INDEX IF NOT EXISTS idx_notifications_recipient_id 
ON public.notifications (recipient_id);

-- Индекс для непрочитанных уведомлений
CREATE INDEX IF NOT EXISTS idx_notifications_unread 
ON public.notifications (recipient_id, read_at) WHERE read_at IS NULL;

-- Индекс для поиска по типу уведомления
CREATE INDEX IF NOT EXISTS idx_notifications_type 
ON public.notifications (type);

-- Индекс для сортировки по времени создания
CREATE INDEX IF NOT EXISTS idx_notifications_created_at 
ON public.notifications (created_at DESC);

-- =============================================================================
-- 7. PROFILES TABLE - Индексы для профилей
-- =============================================================================

-- Индекс для поиска профиля по user_id (основной поиск)
CREATE INDEX IF NOT EXISTS idx_profiles_user_id 
ON public.profiles (user_id);

-- Индекс для поиска по имени (для автодополнения)
CREATE INDEX IF NOT EXISTS idx_profiles_display_name 
ON public.profiles (display_name) WHERE display_name IS NOT NULL;

-- Индекс для поиска по часовому поясу
CREATE INDEX IF NOT EXISTS idx_profiles_timezone 
ON public.profiles (timezone);

-- =============================================================================
-- 8. AVAILABILITIES TABLE - Уже созданы при создании таблицы
-- =============================================================================

-- Эти индексы уже существуют из supabase_availability_table.sql:
-- - idx_availabilities_user_id
-- - idx_availabilities_date_utc  
-- - idx_availabilities_user_date

-- Дополнительный индекс для поиска по статусу
CREATE INDEX IF NOT EXISTS idx_availabilities_status 
ON public.availabilities (status);

-- Индекс для поиска в диапазоне дат
CREATE INDEX IF NOT EXISTS idx_availabilities_date_range 
ON public.availabilities (user_id, date_utc) WHERE deleted_at IS NULL;

-- =============================================================================
-- Проверка созданных индексов
-- =============================================================================

-- Команда для проверки всех индексов:
-- SELECT schemaname, tablename, indexname, indexdef 
-- FROM pg_indexes 
-- WHERE schemaname = 'public' 
-- ORDER BY tablename, indexname;

-- Команда для проверки размера индексов:
-- SELECT schemaname, tablename, attname, n_distinct, correlation 
-- FROM pg_stats 
-- WHERE schemaname = 'public' 
-- ORDER BY tablename;

COMMENT ON SCHEMA public IS 'Performance indexes created for all tables';