-- КРИТИЧНОЕ ИСПРАВЛЕНИЕ: Удаление небезопасных RLS политик
-- Эти политики дают ПОЛНЫЙ ДОСТУП всем пользователям!

-- Удалить небезопасную политику для rehearsal_attendees
DROP POLICY IF EXISTS "Enable all operations for rehearsal_attendees" ON public.rehearsal_attendees;

-- Удалить небезопасные политики для profiles
DROP POLICY IF EXISTS "Enable all operations for profiles" ON public.profiles;

-- Удалить небезопасные политики для projects
DROP POLICY IF EXISTS "Enable all operations for projects" ON public.projects;

-- Удалить небезопасные политики для project_members
DROP POLICY IF EXISTS "Enable all operations for project_members" ON public.project_members;

-- Удалить небезопасные политики для rehearsals
DROP POLICY IF EXISTS "Enable all operations for rehearsals" ON public.rehearsals;

-- Удалить небезопасные политики для rehearsal_participants
DROP POLICY IF EXISTS "Enable all operations for rehearsal_participants" ON public.rehearsal_participants;

-- Удалить небезопасные политики для project_invitations
DROP POLICY IF EXISTS "Enable all operations for project_invitations" ON public.project_invitations;

-- Удалить небезопасные политики для notifications
DROP POLICY IF EXISTS "Enable all operations for notifications" ON public.notifications;

-- =============================================================================
-- ДОПОЛНИТЕЛЬНО: Добавить недостающие политики для rehearsal_attendees
-- =============================================================================

-- Если вы решили оставить rehearsal_attendees, добавьте безопасные политики:

-- Участники проектов видят записи участников репетиций своих проектов
CREATE POLICY "Users can view rehearsal attendees of their projects" ON public.rehearsal_attendees
    FOR SELECT USING (
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

-- Участники проектов могут управлять участием в репетициях
CREATE POLICY "Project members can manage rehearsal attendees" ON public.rehearsal_attendees
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
-- Проверка результатов после исправления
-- =============================================================================

-- Проверить что остались только безопасные политики:
-- SELECT schemaname, tablename, policyname, cmd, qual FROM pg_policies 
-- WHERE schemaname = 'public' AND qual != 'true' OR qual IS NULL;

COMMENT ON SCHEMA public IS 'Security vulnerability fixed - removed permissive policies';