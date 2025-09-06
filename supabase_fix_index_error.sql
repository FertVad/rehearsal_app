-- ИСПРАВЛЕНИЕ: Замена проблематичного индекса
-- Функция now() не может использоваться в предикате индекса

-- Удалить проблематичный индекс (если он частично создался)
DROP INDEX IF EXISTS idx_project_invitations_active;

-- ВАРИАНТ 1: Индекс без предиката (рекомендую)
CREATE INDEX IF NOT EXISTS idx_project_invitations_expires_at 
ON public.project_invitations (expires_at);

-- ВАРИАНТ 2: Если очень нужен фильтрованный индекс, можно использовать конкретную дату
-- Но это не рекомендуется, так как дата станет устаревшей
-- CREATE INDEX IF NOT EXISTS idx_project_invitations_future
-- ON public.project_invitations (expires_at) 
-- WHERE expires_at > '2024-01-01'::timestamptz;

-- АЛЬТЕРНАТИВНОЕ РЕШЕНИЕ: Функциональный индекс
-- Создаем выражение которое показывает "активность" приглашения
CREATE INDEX IF NOT EXISTS idx_project_invitations_is_active 
ON public.project_invitations ((expires_at > CURRENT_TIMESTAMP));

COMMENT ON INDEX idx_project_invitations_expires_at IS 'Index for invitation expiration queries';
COMMENT ON INDEX idx_project_invitations_is_active IS 'Functional index for checking if invitation is still active';