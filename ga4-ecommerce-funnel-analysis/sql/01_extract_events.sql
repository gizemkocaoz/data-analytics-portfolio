/*
Project: GA4 E-commerce Funnel Analysis
File: 01_extract_events.sql

Purpose:
Extract event-level data from the Google Analytics 4 public e-commerce dataset,
including user sessions, traffic source information, and device details.
*/

SELECT
  DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_date,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'source') AS source,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'medium') AS medium,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'campaign') AS campaign,
  COUNT(DISTINCT CONCAT(user_pseudo_id, 
    CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING))
  ) AS user_sessions_count,
  SUM(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS visit_to_cart,
  SUM(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS visit_to_checkout,
  SUM(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS visit_to_purchase
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
WHERE event_name IN UNNEST([
  'session_start',
  'view_item',
  'add_to_cart',
  'begin_checkout',
  'add_shipping_info',
  'add_payment_info',
  'purchase'
])
AND EXTRACT(YEAR FROM TIMESTAMP_MICROS(event_timestamp)) = 2021
GROUP BY event_date, source, medium, campaign
ORDER BY event_date, source, medium, campaign
LIMIT 50
