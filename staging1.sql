-- Removing Duplicates
WITH ranked AS (
    SELECT
        ctid,
        ROW_NUMBER() OVER(PARTITION BY 
            event_id, shipment_id, event_timestamp, event_type, event_location_city, event_location_state, scan_device_id, employee_id 
            ORDER BY ctid) AS rn
    FROM logistics.stg_delivery_events
)

DELETE FROM logistics.stg_delivery_events
WHERE ctid IN (
    SELECT ctid
    FROM ranked
    WHERE rn > 1
);

DELETE FROM logistics.stg_distribution_centers
WHERE center_id = 'DC008'
AND center_name = 'Phoenix Ground Duplicate';

DELETE FROM logistics.stg_shipments 
WHERE order_id = 'ORD-10034-DUP';




