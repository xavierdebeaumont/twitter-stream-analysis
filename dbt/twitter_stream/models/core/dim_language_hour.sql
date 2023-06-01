{{ config(materialized='table') }}

-- Extract language and hour from fact_tweets
with language_hour_counts as (
    select
        language,
        EXTRACT(HOUR FROM created_at) as hour,
        count(*) as frequency,
        stream_rule as stream_rule
    from {{ ref('fact_tweets') }}
    group by language, hour, stream_rule
),

-- Rank languages within each hour
ranked_language_hour as (
    select
        language,
        hour,
        frequency,
        row_number() over (partition by hour order by frequency desc) as rank,
        stream_rule as stream_rule
    from language_hour_counts
)

-- Dimension table: dim_language_hour
select
    language as lang,
    hour,
    frequency,
    stream_rule as stream_rule
from ranked_language_hour
order by hour, frequency desc
