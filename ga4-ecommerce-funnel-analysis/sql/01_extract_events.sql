/*
Project: GA4 E-commerce Funnel Analysis
File: 01_extract_events.sql

Purpose:
Extract event-level data from the Google Analytics 4 public e-commerce dataset,
including user sessions, traffic source information, and device details.
*/

SELECT
  event_timestamp,
  user_pseudo_id,
  event_name,
  geo.country AS country,
  device.category AS device_category,
  (
    SELECT value.int_value
    FROM UNNEST(event_params)
    WHERE key = 'ga_session_id'
  ) AS session_id,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'source') AS source,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'medium') AS medium,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'campaign') AS campaign
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
LIMIT 20
