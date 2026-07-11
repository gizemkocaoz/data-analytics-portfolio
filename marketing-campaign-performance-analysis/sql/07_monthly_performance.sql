/*
Project: Marketing Campaign Performance Analysis
File: 07_monthly_performance.sql

Purpose:
Aggregate advertising performance by month and UTM campaign,
then compare CPM, CTR, and ROMI with the previous month using LAG().
*/

CREATE OR REPLACE FUNCTION url_decode(input TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN REPLACE(REPLACE(input, '%20', ' '), '+', ' ');
END;
$$ LANGUAGE plpgsql;

WITH all_ads AS (

    SELECT
        f.ad_date,
        f.url_parameters,
        COALESCE(f.spend, 0) AS spend,
        COALESCE(f.impressions, 0) AS impressions,
        COALESCE(f.reach, 0) AS reach,
        COALESCE(f.clicks, 0) AS clicks,
        COALESCE(f.leads, 0) AS leads,
        COALESCE(f.value, 0) AS value
    FROM facebook_ads_basic_daily f

    UNION ALL

    SELECT
        g.ad_date,
        g.url_parameters,
        COALESCE(g.spend, 0),
        COALESCE(g.impressions, 0),
        COALESCE(g.reach, 0),
        COALESCE(g.clicks, 0),
        COALESCE(g.leads, 0),
        COALESCE(g.value, 0)
    FROM google_ads_basic_daily g
),

utm_data AS (

    SELECT
        ad_date,
        CASE
            WHEN LOWER(SPLIT_PART(SPLIT_PART(url_parameters, 'utm_campaign=', 2), '&', 1)) = 'nan'
                THEN NULL
            ELSE LOWER(
                url_decode(
                    SPLIT_PART(SPLIT_PART(url_parameters, 'utm_campaign=', 2), '&', 1)
                )
            )
        END AS utm_campaign,
        spend,
        impressions,
        clicks,
        value
    FROM all_ads
),

monthly AS (

    SELECT
        DATE_TRUNC('month', ad_date)::date AS ad_month,
        utm_campaign,
        SUM(spend) AS total_spend,
        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        SUM(value) AS total_value,

        CASE
            WHEN SUM(impressions) = 0 THEN 0
            ELSE SUM(clicks)::numeric / SUM(impressions)
        END AS ctr,

        CASE
            WHEN SUM(clicks) = 0 THEN 0
            ELSE SUM(spend)::numeric / SUM(clicks)
        END AS cpc,

        CASE
            WHEN SUM(impressions) = 0 THEN 0
            ELSE (SUM(spend)::numeric / SUM(impressions)) * 1000
        END AS cpm,

        CASE
            WHEN SUM(spend) = 0 THEN 0
            ELSE (SUM(value) - SUM(spend))::numeric / SUM(spend)
        END AS romi

    FROM utm_data
    GROUP BY 1, 2
)

SELECT
    ad_month,
    utm_campaign,
    total_spend,
    total_impressions,
    total_clicks,
    total_value,
    ctr,
    cpc,
    cpm,
    romi,

    (cpm - LAG(cpm) OVER (PARTITION BY utm_campaign ORDER BY ad_month))
        / NULLIF(LAG(cpm) OVER (PARTITION BY utm_campaign ORDER BY ad_month), 0)
        AS cpm_change_pct,

    (ctr - LAG(ctr) OVER (PARTITION BY utm_campaign ORDER BY ad_month))
        / NULLIF(LAG(ctr) OVER (PARTITION BY utm_campaign ORDER BY ad_month), 0)
        AS ctr_change_pct,

    (romi - LAG(romi) OVER (PARTITION BY utm_campaign ORDER BY ad_month))
        / NULLIF(LAG(romi) OVER (PARTITION BY utm_campaign ORDER BY ad_month), 0)
        AS romi_change_pct

FROM monthly
ORDER BY utm_campaign, ad_month;
