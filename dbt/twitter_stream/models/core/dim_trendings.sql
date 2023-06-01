{{ config(materialized='table') }}

-- Extract trending hashtags from raw_tweets
with trending_hashtags as (
    select
        regexp_extract_all(lower(text), r'#[a-z0-9_]+') as hashtags
    from {{ ref('fact_tweets') }}
),

-- Flatten the hashtags array
flattened_hashtags as (
    select
        unnest(hashtags) as hashtag
    from trending_hashtags
)

-- Dimension table: dim_trending
select
    hashtag,
    count(*) as frequency
from flattened_hashtags
group by hashtag
order by frequency desc