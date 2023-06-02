{{ config(materialized='table') }}

-- Extract trending hashtags from raw_tweets
with trending_hashtags as (
    select
        regexp_extract_all(lower(text), r'#[a-z0-9_]+') as hashtags,
        keyword as keyword,
        created_at as tweet_created_at
    from {{ ref('dim_tweet') }}
),

-- Flatten the hashtags array and extract hour, year, and day
flattened_hashtags as (
    select
        hashtag,
        keyword as keyword,
        timestamp_trunc(tweet_created_at, hour) as hour,
        EXTRACT(YEAR FROM tweet_created_at) as year,
        EXTRACT(DAY FROM tweet_created_at) as day
    from trending_hashtags, unnest(hashtags) as hashtag
)

-- Calculate the frequency of hashtags by hour, year, day, and stream rule
select
    hashtag,
    hour,
    CONCAT(year, '-', LPAD(CAST(day AS STRING), 2, '0')) as date,
    count(*) as frequency,
    keyword as keyword
from flattened_hashtags
group by hashtag, hour, year, day, keyword
order by hour, date, frequency desc
