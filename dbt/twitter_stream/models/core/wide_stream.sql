{{ config(
  materialized = 'table',
  partition_by={
    "field": "created_at",
    "data_type": "timestamp",
    "granularity": "hour"
  }
  ) }}

select
    tweet.author_id as author_id,
    tweet.created_at as created_at,
    tweet.edit_history_tweet_ids as edit_history_tweet_ids,
    tweet.tweet_id as tweet_id,
    tweet.language as language,
    tweet.text as text,
    tweet.keyword as keyword,
    user.user_id as user_id,
    user.created_at as user_created_at,
    user.description as user_description,
    user.name as user_name,
    user.username as username,
    time.year as year,
    time.month as month,
    time.day as day,
    time.hour as hour

from {{ ref('fact_tweets') }} as fact_tweets
join {{ ref('dim_tweet') }} as tweet on fact_tweets.tweet_id = tweet.tweet_id
join {{ ref('dim_user') }} as user on fact_tweets.user_id = user.user_id
join {{ ref('dim_time') }} as time on tweet.created_at = time.timestamp
