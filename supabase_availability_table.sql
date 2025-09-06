-- Создание таблицы availabilities в Supabase
-- Выполните этот SQL в Supabase Dashboard -> SQL Editor

CREATE TABLE public.availabilities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    user_id uuid NOT NULL,
    date_utc bigint NOT NULL,
    status text NOT NULL CHECK (status IN ('free', 'busy', 'partial')),
    intervals_json text,
    note text,
    CONSTRAINT availabilities_pkey PRIMARY KEY (id),
    CONSTRAINT availabilities_user_date_unique UNIQUE (user_id, date_utc),
    CONSTRAINT availabilities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Создание индексов для быстрых запросов
CREATE INDEX idx_availabilities_user_id ON public.availabilities(user_id);
CREATE INDEX idx_availabilities_date_utc ON public.availabilities(date_utc);
CREATE INDEX idx_availabilities_user_date ON public.availabilities(user_id, date_utc);

-- Настройка RLS (Row Level Security)
ALTER TABLE public.availabilities ENABLE ROW LEVEL SECURITY;

-- Политика: пользователи могут видеть только свою доступность
CREATE POLICY "Users can view their own availability" ON public.availabilities
    FOR SELECT USING (auth.uid() = user_id);

-- Политика: пользователи могут создавать свою доступность
CREATE POLICY "Users can insert their own availability" ON public.availabilities
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Политика: пользователи могут обновлять свою доступность
CREATE POLICY "Users can update their own availability" ON public.availabilities
    FOR UPDATE USING (auth.uid() = user_id);

-- Политика: пользователи могут удалять свою доступность
CREATE POLICY "Users can delete their own availability" ON public.availabilities
    FOR DELETE USING (auth.uid() = user_id);

-- Функция для автоматического обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для автоматического обновления updated_at
CREATE TRIGGER update_availabilities_updated_at 
    BEFORE UPDATE ON public.availabilities
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Комментарии к таблице
COMMENT ON TABLE public.availabilities IS 'User availability data for scheduling';
COMMENT ON COLUMN public.availabilities.user_id IS 'Reference to auth.users.id';
COMMENT ON COLUMN public.availabilities.date_utc IS 'Date in milliseconds since epoch (00:00 UTC)';
COMMENT ON COLUMN public.availabilities.status IS 'Availability status: free, busy, or partial';
COMMENT ON COLUMN public.availabilities.intervals_json IS 'JSON array of time intervals when user is available';
COMMENT ON COLUMN public.availabilities.note IS 'Optional note about availability';