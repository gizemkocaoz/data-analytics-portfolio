/*
Project: Marketing Campaign Performance Analysis
File: 06_utm_campaign_analysis.sql

Purpose:
Decode UTM campaign parameters, combine Facebook and Google Ads data,
and calculate campaign-level CTR, CPC, CPM, and ROMI.
*/

create or replace function url_decode(input text)
returns text as $$
begin
    return replace(replace(input, '%20', ' '), '+', ' ');
end;
$$ language plpgsql;

with all_ads as (

    select
        f.ad_date,
        f.url_parameters,
        coalesce(f.spend, 0) as spend,
        coalesce(f.impressions, 0) as impressions,
        coalesce(f.reach, 0) as reach,
        coalesce(f.clicks, 0) as clicks,
        coalesce(f.leads, 0) as leads,
        coalesce(f.value, 0) as value
    from facebook_ads_basic_daily f

    union all

    select
        g.ad_date,
        g.url_parameters,
        coalesce(g.spend, 0),
        coalesce(g.impressions, 0),
        coalesce(g.reach, 0),
        coalesce(g.clicks, 0),
        coalesce(g.leads, 0),
        coalesce(g.value, 0)
    from google_ads_basic_daily g
),

utm_data as (

    select
        ad_date,
        case
            when lower(split_part(split_part(url_parameters, 'utm_campaign=', 2), '&', 1)) = 'nan'
                then null
            else lower(
                url_decode(
                    split_part(split_part(url_parameters, 'utm_campaign=', 2), '&', 1)
                )
            )
        end as utm_campaign,
        spend,
        impressions,
        clicks,
        value
    from all_ads
)

select
    ad_date,
    utm_campaign,
    sum(spend) as total_spend,
    sum(impressions) as total_impressions,
    sum(clicks) as total_clicks,
    sum(value) as total_value,

    case
        when sum(impressions) = 0 then 0
        else sum(clicks)::numeric / sum(impressions)
    end as ctr,

    case
        when sum(clicks) = 0 then 0
        else sum(spend)::numeric / sum(clicks)
    end as cpc,

    case
        when sum(impressions) = 0 then 0
        else (sum(spend)::numeric / sum(impressions)) * 1000
    end as cpm,

    case
        when sum(spend) = 0 then 0
        else (sum(value) - sum(spend))::numeric / sum(spend)
    end as romi

from utm_data
group by ad_date, utm_campaign
order by ad_date;
