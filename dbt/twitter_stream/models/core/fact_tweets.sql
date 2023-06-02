{{ config(
  materialized = 'table',
  partition_by={
    "field": "created_at",
    "data_type": "timestamp",
    "granularity": "hour"
  }
  ) }}

select
    tweet.tweet_id as tweet_id,
    user.user_id as user_id,
    time.timestamp as created_at

from {{ ref('stg_raw_tweets') }} as stg
join {{ ref('dim_tweet') }} as tweet on tweet.tweet_id = stg.id
join {{ ref('dim_user') }} as user on stg.user.id = user.user_id
join {{ ref('dim_time') }} as time on stg.created_at = time.timestamp