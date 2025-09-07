-- Rehearsal App Database Schema
-- Supabase PostgreSQL Schema

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Projects table
CREATE TABLE projects (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    start_date TIMESTAMPTZ,
    end_date TIMESTAMPTZ,
    venue TEXT,
    director_id TEXT,
    owner_id TEXT,
    member_count INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

-- Profiles table (users)
CREATE TABLE profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    username TEXT UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    phone TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Availability table
CREATE TABLE availability (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    date DATE NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('available', 'unavailable', 'maybe')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, date)
);

-- Rehearsals table
CREATE TABLE rehearsals (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    project_id TEXT REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    venue TEXT,
    created_by UUID REFERENCES profiles(id) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Project members table (many-to-many relationship)
CREATE TABLE project_members (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    project_id TEXT REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    role TEXT DEFAULT 'member' CHECK (role IN ('owner', 'director', 'member')),
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(project_id, user_id)
);

-- Rehearsal participants table (many-to-many relationship)
CREATE TABLE rehearsal_participants (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    rehearsal_id UUID REFERENCES rehearsals(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    status TEXT DEFAULT 'invited' CHECK (status IN ('invited', 'accepted', 'declined', 'attended')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(rehearsal_id, user_id)
);

-- Indexes for better performance
CREATE INDEX idx_projects_owner_id ON projects(owner_id);
CREATE INDEX idx_projects_deleted_at ON projects(deleted_at);
CREATE INDEX idx_availability_user_date ON availability(user_id, date);
CREATE INDEX idx_rehearsals_project_id ON rehearsals(project_id);
CREATE INDEX idx_rehearsals_start_time ON rehearsals(start_time);
CREATE INDEX idx_project_members_project_id ON project_members(project_id);
CREATE INDEX idx_project_members_user_id ON project_members(user_id);
CREATE INDEX idx_rehearsal_participants_rehearsal_id ON rehearsal_participants(rehearsal_id);
CREATE INDEX idx_rehearsal_participants_user_id ON rehearsal_participants(user_id);

-- RLS (Row Level Security) Policies
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE rehearsals ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE rehearsal_participants ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

-- Projects policies
CREATE POLICY "Users can view projects they are members of" ON projects
    FOR SELECT USING (
        owner_id = auth.uid()::text OR 
        id IN (
            SELECT project_id FROM project_members 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create projects" ON projects
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Project owners can update their projects" ON projects
    FOR UPDATE USING (owner_id = auth.uid()::text);

CREATE POLICY "Project owners can delete their projects" ON projects
    FOR DELETE USING (owner_id = auth.uid()::text);

-- Availability policies
CREATE POLICY "Users can manage own availability" ON availability
    FOR ALL USING (user_id = auth.uid());

-- Project members can view each other's availability
CREATE POLICY "Project members can view availability" ON availability
    FOR SELECT USING (
        user_id IN (
            SELECT pm.user_id FROM project_members pm
            JOIN project_members pm2 ON pm.project_id = pm2.project_id
            WHERE pm2.user_id = auth.uid()
        )
    );

-- Rehearsals policies
CREATE POLICY "Project members can view rehearsals" ON rehearsals
    FOR SELECT USING (
        project_id IN (
            SELECT project_id FROM project_members 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Project owners and directors can manage rehearsals" ON rehearsals
    FOR ALL USING (
        project_id IN (
            SELECT p.id FROM projects p
            JOIN project_members pm ON p.id = pm.project_id
            WHERE pm.user_id = auth.uid() 
            AND pm.role IN ('owner', 'director')
        )
    );

-- Project members policies
CREATE POLICY "Project members can view project membership" ON project_members
    FOR SELECT USING (
        project_id IN (
            SELECT project_id FROM project_members 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Project owners can manage membership" ON project_members
    FOR ALL USING (
        project_id IN (
            SELECT id FROM projects 
            WHERE owner_id = auth.uid()::text
        )
    );

-- Rehearsal participants policies
CREATE POLICY "Participants can view rehearsal participation" ON rehearsal_participants
    FOR SELECT USING (
        user_id = auth.uid() OR
        rehearsal_id IN (
            SELECT r.id FROM rehearsals r
            JOIN project_members pm ON r.project_id = pm.project_id
            WHERE pm.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update own participation status" ON rehearsal_participants
    FOR UPDATE USING (user_id = auth.uid());

-- Functions and Triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_availability_updated_at BEFORE UPDATE ON availability
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_rehearsals_updated_at BEFORE UPDATE ON rehearsals
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_rehearsal_participants_updated_at BEFORE UPDATE ON rehearsal_participants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();