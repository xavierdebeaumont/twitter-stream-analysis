{{ config(materialized='table') }}

select
    stg_raw_tweets.author_id as author_id,
    stg_raw_tweets.created_at as created_at,
    stg_raw_tweets.edit_history_tweet_ids as edit_history_tweet_ids,
    stg_raw_tweets.id as tweet_id,
    stg_raw_tweets.text as text,
    lang_names.lang_name as language,
    stg_raw_tweets.stream_rule as keyword,
from {{ source('staging', 'stg_raw_tweets') }} as stg_raw_tweets
join {{ source('staging', 'lang_names') }} as lang_names on lang_names.lang_code = stg_raw_tweets.lang