/*
Project: Marketing Campaign Performance Analysis
File: 02_campaign_metrics.sql

Purpose:
Calculate key marketing performance metrics by campaign.
*/

SELECT
    ad_date,
    campaign_id,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(value) AS conversion_value,
    SUM(spend) / NULLIF(SUM(clicks), 0) AS cpc,
    SUM(spend) * 1000.0 / NULLIF(SUM(impressions), 0) AS cpm,
    SUM(clicks)::numeric / NULLIF(SUM(impressions), 0) AS ctr,
    SUM(value) / NULLIF(SUM(spend), 0) AS romi
FROM facebook_ads_basic_daily
GROUP BY ad_date, campaign_id
ORDER BY ad_date DESC;
