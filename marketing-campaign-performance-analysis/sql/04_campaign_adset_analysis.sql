/*
Project: Marketing Campaign Performance Analysis
File: 04_campaign_adset_analysis.sql

Purpose:
Combine Facebook and Google Ads data with campaign and ad set names
for detailed campaign-level performance analysis.
*/

WITH facebook_data AS (
    SELECT
        fabd.ad_date,
        'Facebook Ads' AS media_source,
        fc.campaign_name,
        fa.adset_name,
        fabd.spend,
        fabd.impressions,
        fabd.clicks,
        fabd.value
    FROM facebook_ads_basic_daily AS fabd
    LEFT JOIN facebook_campaign AS fc
        ON fabd.campaign_id = fc.campaign_id
    LEFT JOIN facebook_adset AS fa
        ON fabd.adset_id = fa.adset_id
),

google_data AS (
    SELECT
        ad_date,
        'Google Ads' AS media_source,
        campaign_name,
        adset_name,
        spend,
        impressions,
        clicks,
        value
    FROM google_ads_basic_daily
),

ads_data AS (
    SELECT * FROM facebook_data
    UNION ALL
    SELECT * FROM google_data
)

SELECT
    ad_date,
    media_source,
    campaign_name,
    adset_name,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(value) AS conversion_value
FROM ads_data
GROUP BY
    ad_date,
    media_source,
    campaign_name,
    adset_name
ORDER BY ad_date DESC;
