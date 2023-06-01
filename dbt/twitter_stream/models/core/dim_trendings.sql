{{ config(materialized='table') }}

-- Extract trending hashtags from raw_tweets
with trending_hashtags as (
    select
        regexp_extract_all(lower(text), r'#[a-z0-9_]+') as hashtags,
        stream_rule as stream_rule,
        created_at as tweet_created_at
    from {{ ref('fact_tweets') }}
),

-- Flatten the hashtags array
flattened_hashtags as (
    select
        hashtag,
        stream_rule as stream_rule,
        timestamp_trunc(tweet_created_at, hour) as hour
    from trending_hashtags, unnest(hashtags) as hashtag
)

-- Dimension table: dim_trending
select
    hashtag,
    hour,
    count(*) as frequency,
    stream_rule as stream_rule
from flattened_hashtags
group by hashtag, hour, stream_rule
order by hour, frequency desc