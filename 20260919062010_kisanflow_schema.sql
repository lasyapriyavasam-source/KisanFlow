/*
# KisanFlow Schema — Centres, Farmers, Slots, Bookings

## Overview
KisanFlow is a connected agricultural procurement prototype with three portals
(Farmer, Procurement Centre, Government). Farmer and Centre data is shared:
bookings made by farmers appear in the centre dashboard, and centre updates
(queue, capacity, status, slots) are reflected in the farmer portal in realtime.

## New Tables
1. `centres` — Procurement centres with government-registered identity info
   and centre-editable operational info.
2. `slots` — Time slots belonging to a centre, each with capacity and status.
3. `farmers` — Farmer registrations (name, mobile, village, district, etc.)
4. `bookings` — A booking connecting a farmer, a centre, a slot, produce, and
   quantity. Status flows: pending -> confirmed -> arrived -> completed, or
   cancelled.

## Security
- Single-tenant prototype with no real auth (OTP is mocked). All policies use
  `TO anon, authenticated` with `USING (true)` because the data is
  intentionally shared across the farmer and centre portals.
- RLS enabled on every table.
- CRUD policies (4 per table: select/insert/update/delete).

## Important Notes
1. Centre `status` is one of: open, temporarily_closed, full_capacity, maintenance.
2. Queue level is one of: low, moderate, high, very_high.
3. Booking `status` is one of: pending, confirmed, arrived, completed, cancelled.
4. `image_url` on centres is a Pexels stock photo URL.
*/

-- ===== CENTRES =====
CREATE TABLE IF NOT EXISTS centres (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  centre_id text NOT NULL,
  registration_number text NOT NULL,
  district text NOT NULL,
  village text NOT NULL,
  location_lat double precision DEFAULT 18.0,
  location_lng double precision DEFAULT 78.0,
  address text DEFAULT '',
  contact_person text DEFAULT '',
  mobile_number text DEFAULT '',
  operating_hours text DEFAULT '9:00 AM - 5:00 PM',
  accepted_produce text[] DEFAULT '{}',
  total_capacity_tonnes integer DEFAULT 100,
  used_capacity_tonnes integer DEFAULT 0,
  farmers_waiting integer DEFAULT 0,
  queue_status text DEFAULT 'low',
  status text DEFAULT 'open',
  image_url text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE centres ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_centres" ON centres;
CREATE POLICY "anon_select_centres" ON centres FOR SELECT
  TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_centres" ON centres;
CREATE POLICY "anon_insert_centres" ON centres FOR INSERT
  TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_centres" ON centres;
CREATE POLICY "anon_update_centres" ON centres FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_centres" ON centres;
CREATE POLICY "anon_delete_centres" ON centres FOR DELETE
  TO anon, authenticated USING (true);

-- ===== SLOTS =====
CREATE TABLE IF NOT EXISTS slots (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  centre_id uuid NOT NULL REFERENCES centres(id) ON DELETE CASCADE,
  date text NOT NULL,
  time_label text NOT NULL,
  capacity_tonnes integer DEFAULT 10,
  booked_tonnes integer DEFAULT 0,
  is_open boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE slots ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_slots" ON slots;
CREATE POLICY "anon_select_slots" ON slots FOR SELECT
  TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_slots" ON slots;
CREATE POLICY "anon_insert_slots" ON slots FOR INSERT
  TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_slots" ON slots;
CREATE POLICY "anon_update_slots" ON slots FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_slots" ON slots;
CREATE POLICY "anon_delete_slots" ON slots FOR DELETE
  TO anon, authenticated USING (true);

-- ===== FARMERS =====
CREATE TABLE IF NOT EXISTS farmers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name text NOT NULL,
  mobile_number text NOT NULL,
  village text DEFAULT '',
  district text DEFAULT '',
  state text DEFAULT '',
  aadhaar_number text DEFAULT '',
  land_size_acres numeric DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE farmers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_farmers" ON farmers;
CREATE POLICY "anon_select_farmers" ON farmers FOR SELECT
  TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_farmers" ON farmers;
CREATE POLICY "anon_insert_farmers" ON farmers FOR INSERT
  TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_farmers" ON farmers;
CREATE POLICY "anon_update_farmers" ON farmers FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_farmers" ON farmers;
CREATE POLICY "anon_delete_farmers" ON farmers FOR DELETE
  TO anon, authenticated USING (true);

-- ===== BOOKINGS =====
CREATE TABLE IF NOT EXISTS bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id text NOT NULL,
  farmer_id uuid NOT NULL REFERENCES farmers(id) ON DELETE CASCADE,
  centre_id uuid NOT NULL REFERENCES centres(id) ON DELETE CASCADE,
  slot_id uuid REFERENCES slots(id) ON DELETE SET NULL,
  farmer_name text NOT NULL,
  farmer_mobile text DEFAULT '',
  centre_name text NOT NULL,
  produce text NOT NULL,
  quantity_tonnes numeric NOT NULL DEFAULT 0,
  date text DEFAULT '',
  time_label text DEFAULT '',
  status text NOT NULL DEFAULT 'pending',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_bookings" ON bookings;
CREATE POLICY "anon_select_bookings" ON bookings FOR SELECT
  TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_bookings" ON bookings;
CREATE POLICY "anon_insert_bookings" ON bookings FOR INSERT
  TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_bookings" ON bookings;
CREATE POLICY "anon_update_bookings" ON bookings FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_bookings" ON bookings;
CREATE POLICY "anon_delete_bookings" ON bookings FOR DELETE
  TO anon, authenticated USING (true);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_slots_centre ON slots(centre_id);
CREATE INDEX IF NOT EXISTS idx_bookings_centre ON bookings(centre_id);
CREATE INDEX IF NOT EXISTS idx_bookings_farmer ON bookings(farmer_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
