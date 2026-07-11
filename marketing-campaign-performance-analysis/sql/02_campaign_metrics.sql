/*
Project: Marketing Campaign Performance Analysis
File: 02_campaign_metrics.sql

Purpose:
Calculate daily campaign-level advertising metrics.
*/

SELECT 
    ad_date,
    campaign_id,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(value) AS total_value,
    SUM(spend) / NULLIF(SUM(clicks), 0) AS cpc,
    SUM(spend) / NULLIF(SUM(impressions), 0) * 1000 AS cpm,
    SUM(clicks) / NULLIF(SUM(impressions), 0) * 100 AS ctr,
    SUM(value) / NULLIF(SUM(spend), 0) AS romi
FROM facebook_ads_basic_daily
GROUP BY ad_date, campaign_id;
