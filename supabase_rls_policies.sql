-- Настройка Row Level Security (RLS) политик для всех таблиц
-- Выполните этот SQL в Supabase Dashboard -> SQL Editor

-- =============================================================================
-- 1. PROFILES TABLE - Пользователи видят только свои профили
-- =============================================================================

-- Включить RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Удалить существующие политики (если есть)
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can delete their own profile" ON public.profiles;

-- Создать политики для profiles
CREATE POLICY "Users can view their own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own profile" ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own profile" ON public.profiles
    FOR DELETE USING (auth.uid() = user_id);

-- =============================================================================
-- 2. AVAILABILITIES TABLE - Пользователи видят только свою доступность
-- =============================================================================

-- Включить RLS
ALTER TABLE public.availabilities ENABLE ROW LEVEL SECURITY;

-- Удалить существующие политики (если есть)
DROP POLICY IF EXISTS "Users can view their own availability" ON public.availabilities;
DROP POLICY IF EXISTS "Users can insert their own availability" ON public.availabilities;
DROP POLICY IF EXISTS "Users can update their own availability" ON public.availabilities;
DROP POLICY IF EXISTS "Users can delete their own availability" ON public.availabilities;

-- Создать политики для availabilities
CREATE POLICY "Users can view their own availability" ON public.availabilities
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own availability" ON public.availabilities
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own availability" ON public.availabilities
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own availability" ON public.availabilities
    FOR DELETE USING (auth.uid() = user_id);

-- =============================================================================
-- 3. PROJECTS TABLE - Участники проектов могут читать, создатели - управлять
-- =============================================================================

-- Включить RLS
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

-- Удалить существующие политики (если есть)
DROP POLICY IF EXISTS "Users can view projects they are members of" ON public.projects;
DROP POLICY IF EXISTS "Users can insert their own projects" ON public.projects;
DROP POLICY IF EXISTS "Directors can update their projects" ON public.projects;
DROP POLICY IF EXISTS "Directors can delete their projects" ON public.projects;

-- Политика просмотра: участники проектов могут видеть проекты
CREATE POLICY "Users can view projects they are members of" ON public.projects
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.project_members pm 
            WHERE pm.project_id = projects.id 
            AND pm.profile_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
            AND pm.is_active = true
        )
        OR director_id IN (
            SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
        )
    );

-- Политика создания: пользователи могут создавать проекты
CREATE POLICY "Users can insert their own projects" ON public.projects
    FOR INSERT WITH CHECK (
        director_id IN (
            SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
        )
    );

-- Политика обновления: режиссеры могут обновлять свои проекты
CREATE POLICY "Directors can update their projects" ON public.projects
    FOR UPDATE USING (
        director_id IN (
            SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
        )
    );

-- Политика удаления: режиссеры могут удалять свои проекты
CREATE POLICY "Directors can delete their projects" ON public.projects
    FOR DELETE USING (
        director_id IN (
            SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
        )
    );

-- =============================================================================
-- 4. PROJECT_MEMBERS TABLE - Участники проектов видят членов своих проектов
-- =============================================================================

-- Включить RLS
ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;

-- Удалить существующие политики (если есть)
DROP POLICY IF EXISTS "Users can view members of their projects" ON public.project_members;
DROP POLICY IF EXISTS "Directors can manage project members" ON public.project_members;

-- Политика просмотра: участники видят членов своих проектов
CREATE POLICY "Users can view members of their projects" ON public.project_members
    FOR SELECT USING (
        -- Пользователь является участником этого проекта
        project_id IN (
            SELECT pm.project_id FROM public.project_members pm
            WHERE pm.profile_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
            AND pm.is_active = true
        )
        OR
        -- Пользователь является режиссером этого проекта  
        project_id IN (
            SELECT pr.id FROM public.projects pr
            WHERE pr.director_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
        )
    );

-- Политика управления: режиссеры и админы могут управлять участниками
CREATE POLICY "Directors can manage project members" ON public.project_members
    FOR ALL USING (
        project_id IN (
            SELECT pr.id FROM public.projects pr
            WHERE pr.director_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
        )
        OR
        -- Или пользователь имеет роль admin в этом проекте
        project_id IN (
            SELECT pm.project_id FROM public.project_members pm
            WHERE pm.profile_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
            AND pm.role = 'admin'
            AND pm.is_active = true
        )
    );

-- =============================================================================
-- 5. REHEARSALS TABLE - Участники проектов видят репетиции своих проектов
-- =============================================================================

-- Включить RLS
ALTER TABLE public.rehearsals ENABLE ROW LEVEL SECURITY;

-- Удалить существующие политики (если есть)
DROP POLICY IF EXISTS "Users can view rehearsals of their projects" ON public.rehearsals;
DROP POLICY IF EXISTS "Project members can manage rehearsals" ON public.rehearsals;

-- Политика просмотра: участники проектов видят репетиции
CREATE POLICY "Users can view rehearsals of their projects" ON public.rehearsals
    FOR SELECT USING (
        project_id IN (
            SELECT pm.project_id FROM public.project_members pm
            WHERE pm.profile_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
            AND pm.is_active = true
        )
        OR
        project_id IN (
            SELECT pr.id FROM public.projects pr
            WHERE pr.director_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
        )
    );

-- Политика управления: участники проектов могут создавать/изменять репетиции
CREATE POLICY "Project members can manage rehearsals" ON public.rehearsals
    FOR ALL USING (
        project_id IN (
            SELECT pm.project_id FROM public.project_members pm
            WHERE pm.profile_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
            AND pm.is_active = true
        )
        OR
        project_id IN (
            SELECT pr.id FROM public.projects pr
            WHERE pr.director_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
        )
    );

-- =============================================================================
-- 6. REHEARSAL_PARTICIPANTS TABLE - Участники видят записи по своим репетициям
-- =============================================================================

-- Включить RLS
ALTER TABLE public.rehearsal_participants ENABLE ROW LEVEL SECURITY;

-- Удалить существующие политики (если есть)
DROP POLICY IF EXISTS "Users can view their rehearsal participation" ON public.rehearsal_participants;
DROP POLICY IF EXISTS "Project members can manage rehearsal participants" ON public.rehearsal_participants;

-- Политика просмотра: участники видят свои записи на репетиции
CREATE POLICY "Users can view their rehearsal participation" ON public.rehearsal_participants
    FOR SELECT USING (
        -- Пользователь является участником этой репетиции
        profile_id IN (
            SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
        )
        OR
        -- Или пользователь является участником проекта этой репетиции
        rehearsal_id IN (
            SELECT r.id FROM public.rehearsals r
            WHERE r.project_id IN (
                SELECT pm.project_id FROM public.project_members pm
                WHERE pm.profile_id IN (
                    SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
                )
                AND pm.is_active = true
            )
        )
    );

-- Политика управления: участники проектов могут управлять участием в репетициях
CREATE POLICY "Project members can manage rehearsal participants" ON public.rehearsal_participants
    FOR ALL USING (
        rehearsal_id IN (
            SELECT r.id FROM public.rehearsals r
            WHERE r.project_id IN (
                SELECT pm.project_id FROM public.project_members pm
                WHERE pm.profile_id IN (
                    SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
                )
                AND pm.is_active = true
            )
            OR r.project_id IN (
                SELECT pr.id FROM public.projects pr
                WHERE pr.director_id IN (
                    SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
                )
            )
        )
    );

-- =============================================================================
-- 7. NOTIFICATIONS TABLE - Пользователи видят только свои уведомления
-- =============================================================================

-- Включить RLS
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Удалить существующие политики (если есть)
DROP POLICY IF EXISTS "Users can view their own notifications" ON public.notifications;
DROP POLICY IF EXISTS "Users can update their own notifications" ON public.notifications;

-- Создать политики для notifications
CREATE POLICY "Users can view their own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = recipient_id);

CREATE POLICY "Users can update their own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = recipient_id);

-- =============================================================================
-- 8. PROJECT_INVITATIONS TABLE - Приглашения видят создатели и получатели
-- =============================================================================

-- Включить RLS
ALTER TABLE public.project_invitations ENABLE ROW LEVEL SECURITY;

-- Удалить существующие политики (если есть)
DROP POLICY IF EXISTS "Users can view relevant invitations" ON public.project_invitations;
DROP POLICY IF EXISTS "Project directors can manage invitations" ON public.project_invitations;

-- Политика просмотра: пользователи видят свои приглашения
CREATE POLICY "Users can view relevant invitations" ON public.project_invitations
    FOR SELECT USING (
        -- Пользователь создал приглашение
        invited_by IN (
            SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
        )
        OR
        -- Пользователь получил приглашение
        invited_profile_id IN (
            SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
        )
        OR
        -- Пользователь является режиссером проекта
        project_id IN (
            SELECT pr.id FROM public.projects pr
            WHERE pr.director_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
        )
    );

-- Политика создания: режиссеры могут создавать приглашения
CREATE POLICY "Directors can insert invitations" ON public.project_invitations
    FOR INSERT WITH CHECK (
        project_id IN (
            SELECT pr.id FROM public.projects pr
            WHERE pr.director_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
        )
    );

-- Политика обновления: режиссеры и приглашенные могут обновлять
CREATE POLICY "Directors and invitees can update invitations" ON public.project_invitations
    FOR UPDATE USING (
        -- Режиссер проекта может обновлять
        project_id IN (
            SELECT pr.id FROM public.projects pr
            WHERE pr.director_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
        )
        OR
        -- Приглашенный пользователь может отвечать на приглашение
        invited_profile_id IN (
            SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
        )
    );

-- Политика удаления: только режиссеры могут удалять приглашения
CREATE POLICY "Directors can delete invitations" ON public.project_invitations
    FOR DELETE USING (
        project_id IN (
            SELECT pr.id FROM public.projects pr
            WHERE pr.director_id IN (
                SELECT p.id FROM public.profiles p WHERE p.user_id = auth.uid()
            )
        )
    );

-- =============================================================================
-- Проверка результатов
-- =============================================================================

-- Команда для проверки всех включенных RLS политик:
-- SELECT schemaname, tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public';

-- Команда для просмотра всех политик:  
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual FROM pg_policies WHERE schemaname = 'public';

COMMENT ON SCHEMA public IS 'RLS policies configured for all tables';