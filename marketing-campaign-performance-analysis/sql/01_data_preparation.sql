/*
Project: Marketing Campaign Performance Analysis
File: 01_data_preparation.sql

Purpose:
Retrieve daily Facebook Ads data and prepare it for marketing performance analysis.
*/

SELECT
    ad_date,
    spend,
    impressions,
    reach,
    clicks,
    leads,
    value,
    spend / NULLIF(clicks, 0) AS cpc
FROM facebook_ads_basic_daily
WHERE clicks > 0
ORDER BY ad_date DESC;
