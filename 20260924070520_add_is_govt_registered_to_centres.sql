/*
# Add is_govt_registered column to centres

## Changes
- Adds `is_govt_registered` boolean column to the `centres` table, defaulting to `true`.
  This distinguishes government-registered centres from self-registered (non-govt) ones.
  Used by the Centre Portal NO path (non-govt registration) and the Find Centre page
  (only show Govt Registered badge when this is true).

## Security
- No policy changes. Existing CRUD policies on centres remain unchanged.
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'centres' AND column_name = 'is_govt_registered'
  ) THEN
    ALTER TABLE centres ADD COLUMN is_govt_registered boolean DEFAULT true;
  END IF;
END $$;
