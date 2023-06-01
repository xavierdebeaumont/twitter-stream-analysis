{{ config(materialized='table') }}

-- Extract language and hour from fact_tweets
with language_hour_counts as (
    select
        language,
        date_trunc('hour', created_at) as hour,
        count(*) as frequency
    from {{ ref('fact_tweets') }}
    group by lang, hour
),

-- Rank languages within each hour
ranked_language_hour as (
    select
        lang,
        hour,
        frequency,
        row_number() over (partition by hour order by frequency desc) as rank
    from language_hour_counts
)

-- Dimension table: dim_language_hour
select
    lang,
    hour,
    frequency
from ranked_language_hour
order by hour, frequency desc