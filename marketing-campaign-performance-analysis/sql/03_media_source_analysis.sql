/*
Project: Marketing Campaign Performance Analysis
File: 03_media_source_analysis.sql

Purpose:
Combine Facebook Ads and Google Ads data into a single dataset
and analyze marketing performance by media source.
*/

WITH ads_data AS (

SELECT
    ad_date,
    'Facebook Ads' AS media_source,
    spend,
    impressions,
    clicks,
    value
FROM facebook_ads_basic_daily

UNION ALL

SELECT
    ad_date,
    'Google Ads' AS media_source,
    spend,
    impressions,
    clicks,
    value
FROM google_ads_basic_daily

)

SELECT
    ad_date,
    media_source,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(value) AS conversion_value,
    SUM(spend) / NULLIF(SUM(clicks),0) AS cpc,
    SUM(value) / NULLIF(SUM(spend),0) AS romi
FROM ads_data
GROUP BY ad_date, media_source
ORDER BY ad_date DESC;
