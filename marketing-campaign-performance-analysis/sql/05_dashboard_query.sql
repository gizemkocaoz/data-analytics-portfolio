/*
Project: Marketing Campaign Performance Analysis
File: 05_dashboard_query.sql

Purpose:
Prepare a dataset for Looker Studio dashboard visualization.
*/

SELECT
    ad_date,
    campaign_name,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(value) AS conversion_value,
    ROUND(SUM(spend) / NULLIF(SUM(clicks), 0), 2) AS cpc,
    ROUND(SUM(spend) * 1000.0 / NULLIF(SUM(impressions), 0), 2) AS cpm,
    ROUND(SUM(clicks)::numeric / NULLIF(SUM(impressions), 0), 4) AS ctr,
    ROUND(SUM(value) / NULLIF(SUM(spend), 0), 4) AS romi
FROM ads_data
GROUP BY
    ad_date,
    campaign_name
ORDER BY ad_date;
