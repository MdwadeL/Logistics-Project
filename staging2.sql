-- Standardizing Data
SELECT city
FROM logistics.stg_distribution_centers
WHERE city = 'GREENVILLE';

UPDATE logistics.stg_distribution_centers
SET city = 'Greenville'
WHERE city = 'GREENVILLE';

SELECT state
FROM logistics.stg_distribution_centers
WHERE state = 'Florida';

UPDATE logistics.stg_distribution_centers
SET state = 'FL'
WHERE state = 'Florida';

UPDATE logistics.stg_distribution_centers
SET capacity_per_day = 5000
WHERE capacity_per_day = 'five thousand';

UPDATE logistics.stg_distribution_centers
SET capacity_per_day = 4500
WHERE capacity_per_day = '4500 shipments';


SELECT *
FROM logistics.stg_distribution_centers
WHERE open_date LIKE '%/%';


UPDATE logistics.stg_distribution_centers
SET open_date = TO_CHAR(
    TO_DATE(open_date, 'YYYY/MM/DD'), 'YYYY-MM-DD'
)
WHERE open_date LIKE '%/%';


SELECT *
FROM logistics.stg_delivery_events
WHERE event_timestamp LIKE '%/%';

--We want 10/06/2025 18:45 to be similar to 2025-10-05 12:44:00
UPDATE logistics.stg_delivery_events
SET event_timestamp = TO_CHAR(
    TO_TIMESTAMP(event_timestamp, 'MM/DD/YYYY HH24:MI'), 'YYYY-MM-DD HH24:MI:SS'
)
WHERE event_timestamp LIKE '%/%';


-- We have          Should be
-- delivered        DELIVERED
-- delayed          DELAYED
-- Delayed          DELAYED
-- Delivered        DELIVERED
-- DELIVERED        DELIVERED
-- In Transit       IN_TRANSIT
-- IN TRANSIT       IN_TRANSIT
-- In-Transit       IN_TRANSIT
-- Out For Delivery OUT_FOR_DELIVERY
-- scanned          SCANNED
-- Scanned          SCANNED

UPDATE logistics.stg_delivery_events
SET event_type = REPLACE(event_type, ' ', '_')
WHERE event_type LIKE '% %';

UPDATE logistics.stg_delivery_events
SET event_type = UPPER(event_type);

UPDATE logistics.stg_delivery_events
SET event_type = 'DELIVERED'
WHERE event_type LIKE '%DELIVERED%';

UPDATE logistics.stg_delivery_events
SET event_location_state = 'SC'
WHERE event_location_state = 'S.C.';

UPDATE logistics.stg_delivery_events
SET event_location_state = 'FL'
WHERE event_location_state = 'Florida';

UPDATE logistics.stg_shipments
SET origin_state = 'FL'
WHERE origin_state = 'Florida';

UPDATE logistics.stg_shipments
SET origin_state = 'SC'
WHERE origin_state = 'S.C.';

UPDATE logistics.stg_shipments
SET destination_state = 'SC'
WHERE destination_state = 'South Carolina';

UPDATE logistics.stg_shipments
SET ship_date = TO_CHAR(
    TO_DATE(ship_date, 'MM/DD/YYYY'), 'YYYY-MM-DD'
)
WHERE ship_date LIKE '%/%';


UPDATE logistics.stg_shipments
SET delivery_date = TO_CHAR(
    TO_DATE(delivery_date, 'MM/DD/YYYY'), 'YYYY-MM-DD'
)
WHERE delivery_date LIKE '%/%';

UPDATE logistics.stg_shipments
SET promised_delivery_date = TO_CHAR(
    TO_DATE(promised_delivery_date, 'MM/DD/YYYY'), 'YYYY-MM-DD'
)
WHERE promised_delivery_date LIKE '%/%';

UPDATE logistics.stg_shipments
SET carrier_type = TRIM(carrier_type);

UPDATE logistics.stg_shipments
SET shipping_cost = LTRIM(shipping_cost, '-')
WHERE shipping_cost LIKE '-%';

UPDATE logistics.stg_shipments
SET weight_lbs = NULL
WHERE LOWER(weight_lbs) = 'nan';

UPDATE logistics.stg_shipments
SET carrier_type = UPPER(carrier_type);

-- delivery_status 
-- is              should be
-- delivered       DELIVERED
-- In Transit      IN_TRANSIT
-- Delayed         DELAYED
-- LATE            LATE
-- In-Transit      IN_TRANSIT
-- delayed         DELAYED
-- Late            LATE
-- Delivered       DELIVERED
-- IN TRANSIT      IN_TRANSIT
-- DELIVERED       DELIVERED

UPDATE logistics.stg_shipments
SET delivery_status = REPLACE(delivery_status, '-', '_')
WHERE delivery_status LIKE '%-%';

UPDATE logistics.stg_shipments
SET delivery_status = REPLACE(delivery_status, ' ', '_')
WHERE delivery_status LIKE '% %';

UPDATE logistics.stg_shipments
SET delivery_status = UPPER(delivery_status);

-- delay_reason
-- is                  should be
-- Driver shortage     DRIVER_SHORTAGE
-- Sort delay          SORT_DELAY
-- Weather             WEATHER
-- Address issue       ADDRESS_ISSUE
-- WEATHER             WEATHER
-- Mechanical          MECHANICAL

UPDATE logistics.stg_shipments
SET delay_reason = UPPER(delay_reason);

UPDATE logistics.stg_shipments
SET delay_reason = REPLACE(delay_reason, ' ', '_')
WHERE delay_reason LIKE '% %';

UPDATE logistics.stg_shipments
SET customer_type = UPPER(customer_type);

UPDATE logistics.stg_shipments
SET priority_level = UPPER(priority_level);

UPDATE logistics.stg_distribution_centers
SET region = 'Southeast'
WHERE region LIKE 'SE';


SELECT *
FROM logistics.stg_shipments
ORDER BY shipment_id;

SELECT *
FROM logistics.stg_delivery_events
ORDER BY event_id;

SELECT *
FROM logistics.stg_distribution_centers
ORDER BY center_id;
