/*logistics.stg_shipments
shipment_id
order_id
origin_center_id
origin_city
origin_state
destination_city
destination_state
ship_date
delivery_date
promised_delivery_date
weight_lbs
shipping_cost
carrier_type
delivery_status
delay_reason
customer_type
priority_level

logistics.stg_distribution_centers
center_id
center_name
city
state
capacity_per_day
open_date
manager_name
region

logistics.stg_delivery_events
event_id
shipment_id
event_timestamp
event_type
event_location_city
event_location_state
scan_device_id
employee_id
*/

-- Replacing Nulls
UPDATE logistics.stg_distribution_centers
SET region = 'West'
WHERE state = 'AZ';

SELECT shipment_id, delivery_date, weight_lbs, delay_reason
FROM logistics.stg_shipments
ORDER BY shipment_id;

SELECT * 
FROM logistics.stg_distribution_centers
ORDER BY center_id;

SELECT event_id, shipment_id, scan_device_id, employee_id
FROM logistics.stg_delivery_events
ORDER BY event_id;

DELETE FROM logistics.stg_shipments
WHERE delivery_date < ship_date;

SELECT * FROM logistics.stg_delivery_events;
SELECT * FROM logistics.stg_shipments;
SELECT * FROM logistics.stg_distribution_centers;
