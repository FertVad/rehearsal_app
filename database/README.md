# Database Schema

This directory contains the database schema and documentation for the Rehearsal App.

## Files

- `schema.sql` - Complete PostgreSQL/Supabase schema definition
- `README.md` - This documentation file

## Database Structure

### Core Tables

#### `projects`
Main project entity with project information.
- `id` (TEXT) - Primary key
- `name` (TEXT) - Project name 
- `description` (TEXT) - Optional project description
- `start_date` (TIMESTAMPTZ) - Project start date
- `end_date` (TIMESTAMPTZ) - Project end date
- `venue` (TEXT) - Performance venue
- `director_id` (TEXT) - Project director reference
- `owner_id` (TEXT) - Project owner reference
- `member_count` (INTEGER) - Number of project members

#### `profiles`
User profiles extending Supabase auth.users.
- `id` (UUID) - Primary key, references auth.users(id)
- `email` (TEXT) - User email (unique)
- `username` (TEXT) - Optional username (unique)
- `full_name` (TEXT) - User's full name
- `avatar_url` (TEXT) - Profile picture URL
- `bio` (TEXT) - User biography
- `phone` (TEXT) - Contact phone number

#### `availability`
User availability tracking.
- `id` (UUID) - Primary key
- `user_id` (UUID) - References profiles(id)
- `date` (DATE) - Availability date
- `status` (TEXT) - 'available', 'unavailable', 'maybe'
- Unique constraint on (user_id, date)

#### `rehearsals`
Scheduled rehearsal sessions.
- `id` (UUID) - Primary key
- `project_id` (TEXT) - References projects(id)
- `title` (TEXT) - Rehearsal title
- `description` (TEXT) - Optional description
- `start_time` (TIMESTAMPTZ) - Rehearsal start time
- `end_time` (TIMESTAMPTZ) - Rehearsal end time
- `venue` (TEXT) - Rehearsal location
- `created_by` (UUID) - References profiles(id)

### Relationship Tables

#### `project_members`
Many-to-many relationship between projects and users.
- `project_id` (TEXT) - References projects(id)
- `user_id` (UUID) - References profiles(id)
- `role` (TEXT) - 'owner', 'director', 'member'
- `joined_at` (TIMESTAMPTZ) - When user joined project

#### `rehearsal_participants`
Many-to-many relationship between rehearsals and users.
- `rehearsal_id` (UUID) - References rehearsals(id)
- `user_id` (UUID) - References profiles(id)
- `status` (TEXT) - 'invited', 'accepted', 'declined', 'attended'

## Security

The schema implements Row Level Security (RLS) policies to ensure:
- Users can only see their own profiles and profiles of project members
- Project data is only accessible to project members
- Availability data is private to users and their project teammates
- Rehearsal management is restricted to project owners and directors

## Deployment

To deploy this schema to Supabase:

1. Copy the contents of `schema.sql`
2. Run in Supabase SQL Editor
3. Verify all tables and policies are created correctly

## Maintenance

- `updated_at` columns are automatically maintained via triggers
- Soft delete is implemented for projects using `deleted_at` column
- Indexes are created for optimal query performance