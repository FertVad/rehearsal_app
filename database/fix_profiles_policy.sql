-- Fix INSERT policy for profiles table
-- This allows authenticated users to create their own profile

-- Insert policy for profiles (only with id field that actually exists)
CREATE POLICY "Users can create their own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);