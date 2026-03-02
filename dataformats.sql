ALTER TABLE logistics.stg_shipments

ALTER COLUMN shipment_id TYPE varchar(20),
ALTER COLUMN order_id TYPE varchar(20),
ALTER COLUMN origin_center_id TYPE varchar(10),

ALTER COLUMN origin_city TYPE varchar(50),
ALTER COLUMN origin_state TYPE char(2),

ALTER COLUMN destination_city TYPE varchar(50),
ALTER COLUMN destination_state TYPE char(2),

ALTER COLUMN ship_date TYPE date
USING ship_date::date,

ALTER COLUMN delivery_date TYPE date
USING delivery_date::date,

ALTER COLUMN promised_delivery_date TYPE date
USING promised_delivery_date::date,

ALTER COLUMN weight_lbs TYPE numeric(10,2)
USING weight_lbs::numeric,

ALTER COLUMN shipping_cost TYPE numeric(10,2)
USING shipping_cost::numeric,

ALTER COLUMN carrier_type TYPE varchar(20),
ALTER COLUMN delivery_status TYPE varchar(30),
ALTER COLUMN delay_reason TYPE varchar(50),
ALTER COLUMN customer_type TYPE varchar(20),
ALTER COLUMN priority_level TYPE varchar(20);

ALTER TABLE logistics.stg_distribution_centers

ALTER COLUMN center_id TYPE varchar(10),
ALTER COLUMN center_name TYPE varchar(100),
ALTER COLUMN city TYPE varchar(50),
ALTER COLUMN state TYPE char(2),

ALTER COLUMN capacity_per_day TYPE integer
USING capacity_per_day::integer,

ALTER COLUMN open_date TYPE date
USING open_date::date,

ALTER COLUMN manager_name TYPE varchar(100),
ALTER COLUMN region TYPE varchar(20);

ALTER TABLE logistics.stg_delivery_events

ALTER COLUMN event_id TYPE varchar(20),
ALTER COLUMN shipment_id TYPE varchar(20),

ALTER COLUMN event_timestamp TYPE timestamp
USING event_timestamp::timestamp,

ALTER COLUMN event_type TYPE varchar(30),

ALTER COLUMN event_location_city TYPE varchar(50),
ALTER COLUMN event_location_state TYPE char(2),

ALTER COLUMN scan_device_id TYPE varchar(20),
ALTER COLUMN employee_id TYPE varchar(20);

ALTER TABLE logistics.stg_shipments
ADD CONSTRAINT positive_weight CHECK (weight_lbs >= 0);

ALTER TABLE logistics.stg_shipments
ADD CONSTRAINT positive_cost CHECK (shipping_cost >= 0);
