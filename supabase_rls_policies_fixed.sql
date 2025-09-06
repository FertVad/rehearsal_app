-- ИСПРАВЛЕННАЯ версия RLS политик
-- Исправление ошибки TG_OP в project_invitations

-- =============================================================================
-- 8. PROJECT_INVITATIONS TABLE - ИСПРАВЛЕННАЯ ВЕРСИЯ
-- =============================================================================

-- Включить RLS
ALTER TABLE public.project_invitations ENABLE ROW LEVEL SECURITY;

-- Удалить все существующие политики
DROP POLICY IF EXISTS "Users can view relevant invitations" ON public.project_invitations;
DROP POLICY IF EXISTS "Project directors can manage invitations" ON public.project_invitations;
DROP POLICY IF EXISTS "Directors can insert invitations" ON public.project_invitations;
DROP POLICY IF EXISTS "Directors can update invitations" ON public.project_invitations;
DROP POLICY IF EXISTS "Invitees can respond to invitations" ON public.project_invitations;
DROP POLICY IF EXISTS "Directors can delete invitations" ON public.project_invitations;

-- Политика просмотра: пользователи видят релевантные приглашения
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