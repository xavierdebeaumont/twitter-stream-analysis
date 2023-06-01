{{ config(
  materialized = 'table',
  partition_by={
    "field": "created_at",
    "data_type": "timestamp",
    "granularity": "hour"
  }
  ) }}

select
    stg_raw_tweets.author_id as author_id,
    stg_raw_tweets.created_at as created_at,
    stg_raw_tweets.edit_history_tweet_ids as edit_history_tweet_ids,
    stg_raw_tweets.id as id,
    lang_names.lang_name as language,
    stg_raw_tweets.text as text,
    stg_raw_tweets.stream_rule as stream_rule,
    dim_user.user_id as user_id,
    dim_user.user_created_at as user_created_at,
    dim_user.description as user_description,
    dim_user.name as user_name,
    dim_user.username as username
from {{ ref('stg_raw_tweets') }} as stg_raw_tweets
join {{ ref('dim_user') }} as dim_user on stg_raw_tweets.user.id = dim_user.user_id
join {{ ref('lang_names') }} as lang_names on lang_names.lang_code = stg_raw_tweets.lang