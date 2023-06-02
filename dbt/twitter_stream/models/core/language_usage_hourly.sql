{{ config(materialized='table') }}

-- Extract language, hour, year, and day from fact_tweets
with language_hour_counts as (
    select
        language,
        EXTRACT(HOUR FROM created_at) as hour,
        EXTRACT(YEAR FROM created_at) as year,
        EXTRACT(DAY FROM created_at) as day,
        count(*) as frequency,
        keyword as keyword
    from {{ ref('dim_tweet') }}
    group by language, hour, year, day, keyword
),

-- Rank languages within each hour
ranked_language_hour as (
    select
        language,
        hour,
        year,
        day,
        frequency,
        row_number() over (partition by hour order by frequency desc) as rank,
        keyword as keyword
    from language_hour_counts
)

select
    language as lang,
    hour,
    CONCAT(year, '-', LPAD(CAST(day AS STRING), 2, '0')) as date,
    frequency,
    keyword as keyword
from ranked_language_hour
order by hour, date, frequency desc