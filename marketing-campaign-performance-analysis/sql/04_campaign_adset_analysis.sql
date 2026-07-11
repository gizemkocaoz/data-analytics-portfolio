/*
Project: Marketing Campaign Performance Analysis
File: 04_campaign_adset_analysis.sql

Purpose:
Combine Facebook and Google Ads data with campaign and ad set names
for detailed performance analysis.
*/

WITH facebook_data AS (
    SELECT
        fbd.ad_date,
        'Facebook Ads' AS media_source,
        fc.campaign_name,
        fa.adset_name,
        CAST(fbd.spend AS numeric) AS spend,
        CAST(fbd.impressions AS numeric) AS impressions,
        CAST(fbd.reach AS numeric) AS reach,
        CAST(fbd.clicks AS numeric) AS clicks,
        CAST(fbd.leads AS numeric) AS leads,
        CAST(fbd.value AS numeric) AS value
    FROM facebook_ads_basic_daily fbd
    LEFT JOIN facebook_adset fa
        ON fbd.adset_id = fa.adset_id
    LEFT JOIN facebook_campaign fc
        ON fbd.campaign_id = fc.campaign_id
),
google_data AS (
    SELECT
        gbd.ad_date,
        'Google Ads' AS media_source,
        gbd.campaign_name,
        gbd.adset_name,
        CAST(gbd.spend AS numeric) AS spend,
        CAST(gbd.impressions AS numeric) AS impressions,
        CAST(gbd.reach AS numeric) AS reach,
        CAST(gbd.clicks AS numeric) AS clicks,
        CAST(gbd.leads AS numeric) AS leads,
        CAST(gbd.value AS numeric) AS value
    FROM google_ads_basic_daily gbd
),
combined_data AS (
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
    SUM(value) AS total_conversion_value
FROM combined_data
GROUP BY
    ad_date,
    media_source,
    campaign_name,
    adset_name
ORDER BY
    ad_date,
    media_source,
    campaign_name;
