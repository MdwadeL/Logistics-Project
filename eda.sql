/*  =========================================================
logistics.stg_shipments
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

    EXPLORATORY DATA ANALYSIS (EDA) QUESTIONS
    SELECT * FROM logistics.stg_delivery_events;
    SELECT * FROM logistics.stg_distribution_centers;
    SELECT * FROM logistics.stg_shipments;
    ========================================================= */

/*  =========================
    DELIVERY DELAYS
    ========================= */

-- 1. What percentage of shipments are delivered late?
--^^
SELECT 
    COUNT(*) FILTER(WHERE delivery_status = 'LATE') AS amount_of_late, 
    COUNT(*) AS total_shipments,
    ROUND(
        100 * COUNT(*) FILTER(WHERE delivery_status = 'LATE') 
        / COUNT(*), 
        2
    ) AS percent_late
FROM logistics.stg_shipments;
--**

--^^
-- 2. What is the average number of days between ship_date and delivery_date?
SELECT ROUND(AVG(delivery_date - ship_date), 2) AS avg_transit_days
FROM logistics.stg_shipments
WHERE delivery_date > ship_date;
--**

-- 3. What is the average delay time compared to promised_delivery_date?
--^^
SELECT ROUND(AVG(delivery_date - promised_delivery_date), 2) AS avg_delay_days
FROM logistics.stg_shipments
WHERE delivery_date > promised_delivery_date;
--**

-- 4. Which delay_reason occurs most frequently?
--^^
SELECT delay_reason, COUNT(delay_reason)
FROM logistics.stg_shipments
WHERE delay_reason IS NOT NULL
GROUP BY delay_reason
ORDER BY COUNT(delay_reason) DESC;
--**
-- 5. Which carrier_type has the highest delay rate?
--^^
SELECT 
    carrier_type, 
    COUNT(*) FILTER(WHERE delay_reason IS NOT NULL) AS delayed_total,
    COUNT(*) AS total_shipment,
    ROUND(
        100 * COUNT(*) FILTER(WHERE delay_reason IS NOT NULL)
        / COUNT(*),
        2
    ) as delayed_percent
FROM logistics.stg_shipments
GROUP BY carrier_type;
--**

-- 6. Do certain origin_state or destination_state values show higher delay frequency?
--^^
SELECT 
    origin_state,
    COUNT(*) AS total_shipments,
    COUNT(*) FILTER (WHERE delivery_date > promised_delivery_date) AS delayed_shipments,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE delivery_date > promised_delivery_date) 
        / COUNT(*),
        2
    ) AS delay_percentage
FROM logistics.stg_shipments
GROUP BY origin_state
ORDER BY delay_percentage DESC;
--**

-- 7. Are EXPRESS shipments less likely to be delayed than STANDARD shipments?
--^^
SELECT 
    priority_level,
    COUNT(*) AS total_shipments,
    COUNT(*) FILTER (WHERE delivery_date > promised_delivery_date) AS delayed_shipments,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE delivery_date > promised_delivery_date) 
        / COUNT(*),
        2
    ) AS priority_percentage
FROM logistics.stg_shipments
GROUP BY priority_level
ORDER BY priority_percentage;
--**

-- 8. Are RESIDENTIAL shipments delayed more often than BUSINESS shipments?
--^^
SELECT 
    customer_type,
    COUNT(*) AS total_shipments,
    COUNT(*) FILTER (WHERE delivery_date > promised_delivery_date) AS delayed_shipments,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE delivery_date > promised_delivery_date) 
        / COUNT(*),
        2
    ) AS delay_percentage
FROM logistics.stg_shipments
GROUP BY customer_type
ORDER BY delay_percentage DESC;
--**


/*  =========================
    ROUTE PERFORMANCE
    ========================= */

-- 9. What are the most common origin_city → destination_city routes?
--^^
SELECT 
    origin_city,
    destination_city,
    COUNT(*) AS route_count
FROM logistics.stg_shipments
GROUP BY origin_city, destination_city
ORDER BY route_count DESC;
--**

-- 10. Which routes have the highest late-delivery percentage?
--^^
SELECT 
    origin_city || ' to ' || destination_city AS route,
    COUNT (*) FILTER(WHERE delivery_status = 'LATE') AS delivered_late,
    COUNT(*) as total_route_delivered,
    ROUND(
        100 * COUNT (*) FILTER(WHERE delivery_status = 'LATE') 
        / COUNT(*),
        2
    ) as percent_late
FROM logistics.stg_shipments
GROUP BY route
ORDER BY percent_late DESC;
--**

-- 11. What is the average delivery time by route?
--^^
SELECT 
    origin_city, 
    destination_city,
    ROUND(AVG(delivery_date - ship_date), 2) AS avg_transit_days
FROM logistics.stg_shipments
GROUP BY origin_city, destination_city
ORDER BY origin_city;
--**

-- 12. Which routes generate the highest shipping_cost?
--^^
SELECT 
    origin_city,
    destination_city,
    SUM(shipping_cost) AS total_shipping_cost
FROM logistics.stg_shipments
GROUP BY origin_city, destination_city
ORDER BY total_shipping_cost DESC;
--**

-- 13. Which routes carry the highest average weight_lbs?
--^^
SELECT
    origin_city,
    destination_city,
    AVG(weight_lbs) AS avg_weight_lbs
FROM logistics.stg_shipments
GROUP BY origin_city, destination_city
ORDER BY avg_weight_lbs DESC;
--**

/*  =========================
    CARRIER EFFICIENCY
    ========================= */

-- 15. What is the on-time delivery rate by carrier_type?
-- Late and delayed are cleary not on-time deliveries, but querying on that information 
--      will include in-transit deliveryes that aren't passed promised delivery date
-- NOT being on time is defined by delievered date being past promised delivered date. 
-- Which includes late, delayed, and in transit when the promised delievery date isn't met.
--^^
SELECT 
    carrier_type,
    COUNT(*) FILTER(WHERE (delivery_date > promised_delivery_date) IS TRUE) as total_is_late,
    COUNT(*) AS total_shipments,
    ROUND(
        100 * COUNT(*) FILTER(WHERE (delivery_date > promised_delivery_date) IS TRUE)
        / COUNT(*),
        2
    ) AS percent_late_by_carrier_type
FROM logistics.stg_shipments
GROUP BY carrier_type
ORDER BY carrier_type;
--**

-- 16. What is the average shipping_cost by carrier_type?
--^^
SELECT 
    carrier_type, 
    SUM(shipping_cost) AS total_shipping_cost, 
    COUNT(*) AS total_shipments,
    ROUND(AVG(shipping_cost), 2) as avg_shipping_cost
FROM logistics.stg_shipments
GROUP BY carrier_type
ORDER BY carrier_type;
--**

-- 17. What is the average delivery time by carrier_type?
--^^
SELECT
    carrier_type,
    AVG(delivery_date - ship_date) AS avg_delivery_time
FROM logistics.stg_shipments
GROUP BY carrier_type
ORDER BY avg_delivery_time;
--**

-- 18. Which carrier_type handles the highest shipment volume?
--^^
SELECT
    carrier_type,
    COUNT(*) AS shipment_volume
FROM logistics.stg_shipments
GROUP BY carrier_type
ORDER BY shipment_volume DESC;
--**

-- 19. What is the average cost per pound (shipping_cost / weight_lbs) by carrier?
--^^
SELECT
    carrier_type,
    AVG(shipping_cost / weight_lbs) AS avg_cost_per_lb
FROM logistics.stg_shipments
WHERE weight_lbs > 0
GROUP BY carrier_type
ORDER BY avg_cost_per_lb DESC;
--**

-- 20. Is higher shipping_cost associated with fewer delays?
--^^
SELECT
    CASE
        WHEN shipping_cost < 100 THEN 'Low Cost'
        WHEN shipping_cost BETWEEN 100 AND 300 THEN 'Medium Cost'
        ELSE 'High Cost'
    END AS cost_category,
    COUNT(*) AS shipment_count,
    AVG(delivery_date - promised_delivery_date) AS avg_delay_days
FROM logistics.stg_shipments
WHERE delivery_date IS NOT NULL
  AND promised_delivery_date IS NOT NULL
GROUP BY cost_category
ORDER BY avg_delay_days;
--**

/*  =========================
    OPERATIONAL BOTTLENECKS
    ========================= */

-- 21. Which origin_center_id processes the most shipments?
--^^
SELECT
  origin_center_id,
  COUNT(*) AS shipment_count
FROM logistics.stg_shipments
GROUP BY origin_center_id
ORDER BY shipment_count DESC;
--**

-- 22. Which distribution centers are associated with the most delayed shipments?
--^^
SELECT
  origin_center_id,
  COUNT(*) AS delayed_shipments
FROM logistics.stg_shipments
WHERE delivery_date IS NOT NULL
  AND promised_delivery_date IS NOT NULL
  AND delivery_date > promised_delivery_date
GROUP BY origin_center_id
ORDER BY delayed_shipments DESC;
--**

-- 23. Are delays concentrated in specific event_location_city values?
--^^
SELECT
  event_location_city,
  COUNT(*) AS delayed_event_count,
  COUNT(DISTINCT shipment_id) AS delayed_shipments
FROM logistics.stg_delivery_events
WHERE event_type = 'DELAYED'
GROUP BY event_location_city
ORDER BY delayed_shipments DESC;
--**

-- 24. What event_type most commonly occurs before a DELAYED event?
--^^
WITH delayed AS (
  SELECT shipment_id, event_timestamp AS delayed_ts
  FROM logistics.stg_delivery_events
  WHERE event_type = 'DELAYED'
),
prev AS (
  SELECT
    e.shipment_id,
    e.event_type,
    ROW_NUMBER() OVER (
      PARTITION BY e.shipment_id, d.delayed_ts
      ORDER BY e.event_timestamp DESC
    ) AS rn
  FROM logistics.stg_delivery_events e
  JOIN delayed d
    ON e.shipment_id = d.shipment_id
   AND e.event_timestamp < d.delayed_ts
)
SELECT
  event_type,
  COUNT(*) AS occurrences
FROM prev
WHERE rn = 1
GROUP BY event_type
ORDER BY occurrences DESC;
--**

-- 25. What is the average time gap between event_timestamp records?
--^^
WITH gaps AS (
  SELECT
    shipment_id,
    EXTRACT(EPOCH FROM (event_timestamp - LAG(event_timestamp)
      OVER (PARTITION BY shipment_id ORDER BY event_timestamp))) AS gap_seconds
  FROM logistics.stg_delivery_events
)
SELECT
  AVG(gap_seconds) AS avg_gap_seconds,
  AVG(gap_seconds)/60 AS avg_gap_minutes,
  AVG(gap_seconds)/3600 AS avg_gap_hours
FROM gaps
WHERE gap_seconds IS NOT NULL;
--**

-- 26. Does capacity_per_day correlate with delay frequency?
--^^
WITH center_delay AS (
  SELECT
    origin_center_id AS center_id,
    COUNT(*) AS shipments,
    AVG((delivery_date > promised_delivery_date)::int::numeric) AS delay_rate
  FROM logistics.stg_shipments
  WHERE delivery_date IS NOT NULL
    AND promised_delivery_date IS NOT NULL
  GROUP BY origin_center_id
)
SELECT
  c.center_id,
  c.center_name,
  c.city,
  c.state,
  c.region,
  c.capacity_per_day,
  cd.shipments,
  cd.delay_rate
FROM center_delay cd
JOIN logistics.stg_distribution_centers c
  ON c.center_id = cd.center_id
ORDER BY c.capacity_per_day;
--**


/*  =========================
    DATA QUALITY CHECKS
    ========================= */

-- 27. Are there duplicate shipment_id values?
--^^
SELECT
  shipment_id,
  COUNT(*) AS cnt
FROM logistics.stg_shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC, shipment_id;
--**


-- 28. Are there duplicate event_id values?
--^^
SELECT
  event_id,
  COUNT(*) AS cnt
FROM logistics.stg_delivery_events
GROUP BY event_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC, event_id;
--**


-- 29. Are there shipments marked DELIVERED but with NULL delivery_date?
--^^
SELECT
  COUNT(*) AS delivered_with_null_delivery_date
FROM logistics.stg_shipments
WHERE delivery_status = 'DELIVERED'
  AND delivery_date IS NULL;
--**


-- 30. Are there promised_delivery_date values earlier than ship_date?
--^^
SELECT
  COUNT(*) AS promised_before_ship
FROM logistics.stg_shipments
WHERE promised_delivery_date IS NOT NULL
  AND ship_date IS NOT NULL
  AND promised_delivery_date < ship_date;
--**


-- 31. Are there delivery_date values earlier than ship_date?
--^^
SELECT
  COUNT(*) AS delivered_before_ship
FROM logistics.stg_shipments
WHERE delivery_date IS NOT NULL
  AND ship_date IS NOT NULL
  AND delivery_date < ship_date;
--**


-- 32. Are there NULL values in critical columns (shipment_id, origin_state, ship_date)?
--^^
SELECT
  SUM((shipment_id IS NULL)::int) AS null_shipment_id,
  SUM((origin_state IS NULL)::int) AS null_origin_state,
  SUM((ship_date IS NULL)::int) AS null_ship_date
FROM logistics.stg_shipments;
--**

-- 33. Are there unrealistic shipping_cost values (negative or extremely high)?
--^^
WITH stats AS (
    SELECT
        percentile_cont(0.25) WITHIN GROUP (ORDER BY shipping_cost) AS q1,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY shipping_cost) AS q3
    FROM logistics.stg_shipments
    WHERE shipping_cost IS NOT NULL
),
bounds AS (
    SELECT
        q1,
        q3,
        (q3 - q1) AS iqr,
        (q1 - 1.5 * (q3 - q1)) AS lower_bound,
        (q3 + 1.5 * (q3 - q1)) AS upper_bound
    FROM stats
)
SELECT s.shipment_id, s.shipping_cost
FROM logistics.stg_shipments s
CROSS JOIN bounds b
WHERE s.shipping_cost < b.lower_bound
    OR s.shipping_cost > b.upper_bound;
--**

-- 34. Are there unrealistic weight_lbs values (zero or negative)?
--^^
SELECT shipment_id, weight_lbs
FROM logistics.stg_shipments
WHERE weight_lbs <= 0;
--**
