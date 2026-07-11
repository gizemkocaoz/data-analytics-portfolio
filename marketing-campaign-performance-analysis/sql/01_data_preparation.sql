/*
Project: Marketing Campaign Performance Analysis
File: 01_data_preparation.sql

Purpose:
Retrieve daily Facebook Ads data and calculate cost per click.
*/

SELECT 
    ad_date,
    spend,
    clicks,
    spend / clicks AS cost_per_click
FROM facebook_ads_basic_daily
WHERE clicks > 0
ORDER BY ad_date DESC;/*
Project: Marketing Campaign Performance Analysis
File: 01_data_preparation.sql

Purpose:
Retrieve daily Facebook Ads data and calculate cost per click.
*/

SELECT 
    ad_date,
    spend,
    clicks,
    spend / clicks AS cost_per_click
FROM facebook_ads_basic_daily
WHERE clicks > 0
ORDER BY ad_date DESC;
