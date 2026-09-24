export type CentreStatus = 'open' | 'temporarily_closed' | 'full_capacity' | 'maintenance';
export type QueueStatus = 'low' | 'moderate' | 'high' | 'very_high';
export type BookingStatus = 'pending' | 'confirmed' | 'arrived' | 'completed' | 'cancelled';

export interface Centre {
  id: string;
  name: string;
  centre_id: string;
  registration_number: string;
  district: string;
  village: string;
  location_lat: number;
  location_lng: number;
  address: string;
  contact_person: string;
  mobile_number: string;
  operating_hours: string;
  accepted_produce: string[];
  total_capacity_tonnes: number;
  used_capacity_tonnes: number;
  farmers_waiting: number;
  queue_status: QueueStatus;
  status: CentreStatus;
  image_url: string;
  created_at: string;
  updated_at: string;
}

export interface Slot {
  id: string;
  centre_id: string;
  date: string;
  time_label: string;
  capacity_tonnes: number;
  booked_tonnes: number;
  is_open: boolean;
}

export interface Farmer {
  id: string;
  full_name: string;
  mobile_number: string;
  village: string;
  district: string;
  state: string;
  aadhaar_number: string;
  land_size_acres: number;
  created_at: string;
}

export interface Booking {
  id: string;
  booking_id: string;
  farmer_id: string;
  centre_id: string;
  slot_id: string | null;
  farmer_name: string;
  farmer_mobile: string;
  centre_name: string;
  produce: string;
  quantity_tonnes: number;
  date: string;
  time_label: string;
  status: BookingStatus;
  created_at: string;
  updated_at: string;
}

export interface ProduceDetails {
  produce: string;
  quantityTonnes: number;
  village: string;
  district: string;
  state: string;
  date: string;
  timeSlot: string;
}

export type Language = 'en' | 'te' | 'hi';
export type Portal = 'home' | 'farmer' | 'centre' | 'government';
