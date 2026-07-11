/*
Project: Marketing Campaign Performance Analysis
File: 05_top_campaign_analysis.sql

Purpose:
Identify the highest-ROMI campaign among campaigns with total spend
above 500,000 and find its best-performing ad set.
*/

WITH facebook_data AS (
    SELECT
        fbd.ad_date,
        'Facebook Ads' AS media_source,
        fc.campaign_name,
        fa.adset_name,
        CAST(fbd.spend AS numeric) AS spend,
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
        CAST(gbd.value AS numeric) AS value
    FROM google_ads_basic_daily gbd
),
combined_data AS (
    SELECT * FROM facebook_data
    UNION ALL
    SELECT * FROM google_data
),
campaign_summary AS (
    SELECT
        campaign_name,
        SUM(spend) AS total_spend,
        SUM(value) AS total_value,
        SUM(value) / NULLIF(SUM(spend), 0) AS romi
    FROM combined_data
    GROUP BY campaign_name
    HAVING SUM(spend) > 500000
),
top_campaign AS (
    SELECT *
    FROM campaign_summary
    ORDER BY romi DESC
    LIMIT 1
)
SELECT
    c.campaign_name,
    d.adset_name,
    SUM(d.spend) AS adset_spend,
    SUM(d.value) AS adset_value,
    SUM(d.value) / NULLIF(SUM(d.spend), 0) AS adset_romi
FROM combined_data d
JOIN top_campaign c
    ON d.campaign_name = c.campaign_name
GROUP BY
    c.campaign_name,
    d.adset_name
ORDER BY adset_romi DESC
LIMIT 1;
