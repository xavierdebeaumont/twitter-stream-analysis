{{ config(materialized='table') }}

-- Extract language, hour, year, and day from fact_tweets
with language_hour_counts as (
    select
        language,
        EXTRACT(HOUR FROM created_at) as hour,
        DATE_TRUNC(created_at, HOUR) as truncated_hour,
        count(*) as frequency,
        keyword as keyword
    from {{ ref('dim_tweet') }}
    group by language, hour, truncated_hour, keyword
),

-- Rank languages within each hour
ranked_language_hour as (
    select
        language,
        hour,
        truncated_hour,
        frequency,
        row_number() over (partition by hour order by frequency desc) as rank,
        keyword as keyword
    from language_hour_counts
)

select
    language as language,
    hour,
    truncated_hour as date,
    frequency,
    keyword as keyword
from ranked_language_hour
order by hour, truncated_hour, frequency desc