/*
Project: Marketing Campaign Performance Analysis
File: 03_media_source_analysis.sql

Purpose:
Combine Facebook Ads and Google Ads data and analyze performance by media source.
*/

WITH merged_ads AS (

    SELECT
        ad_date,
        'Facebook Ads' AS media_source,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    FROM facebook_ads_basic_daily

    UNION ALL

    SELECT
        ad_date,
        'Google Ads' AS media_source,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    FROM google_ads_basic_daily

)

SELECT
    ad_date,
    media_source,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(value) AS total_value
FROM merged_ads
GROUP BY
    ad_date,
    media_source
ORDER BY
    ad_date DESC,
    media_source;
