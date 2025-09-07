-- Query to check actual structure of profiles table
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'profiles' 
ORDER BY ordinal_position;

-- Query to see what's actually in the profiles table
SELECT * FROM profiles LIMIT 5;