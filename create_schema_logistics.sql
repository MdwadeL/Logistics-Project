DROP SCHEMA IF EXISTS logistics CASCADE;
CREATE SCHEMA logistics;

CREATE TABLE logistics.stg_distribution_centers (
  center_id TEXT,
  center_name TEXT,
  city TEXT,
  state TEXT,
  capacity_per_day TEXT,
  open_date TEXT,
  manager_name TEXT,
  region TEXT
);

CREATE TABLE logistics.stg_shipments (
  shipment_id TEXT,
  order_id TEXT,
  origin_center_id TEXT,
  origin_city TEXT,
  origin_state TEXT,
  destination_city TEXT,
  destination_state TEXT,
  ship_date TEXT,
  delivery_date TEXT,
  promised_delivery_date TEXT,
  weight_lbs TEXT,
  shipping_cost TEXT,
  carrier_type TEXT,
  delivery_status TEXT,
  delay_reason TEXT,
  customer_type TEXT,
  priority_level TEXT
);

CREATE TABLE logistics.stg_delivery_events (
  event_id TEXT,
  shipment_id TEXT,
  event_timestamp TEXT,
  event_type TEXT,
  event_location_city TEXT,
  event_location_state TEXT,
  scan_device_id TEXT,
  employee_id TEXT
);