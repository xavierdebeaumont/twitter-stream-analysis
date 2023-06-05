{{ config(materialized='table') }}

-- Extract trending hashtags from raw_tweets
with trending_hashtags as (
    select
        regexp_extract_all(lower(text), r'#[a-z0-9_]+') as hashtags,
        keyword as keyword,
        created_at as tweet_created_at
    from {{ ref('dim_tweet') }}
),

-- Flatten the hashtags array and extract hour to truncate the date
flattened_hashtags as (
    select
        hashtag,
        keyword as keyword,
        timestamp_trunc(tweet_created_at, hour) as date,
    from trending_hashtags, unnest(hashtags) as hashtag
)

-- Calculate the frequency of hashtags by date and stream rule
select
    hashtag,
    date,
    count(*) as frequency,
    keyword as keyword
from flattened_hashtags
group by hashtag, keyword
order by date, frequency desc
