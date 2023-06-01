{{ config(materialized='view') }}

-- Convert raw_tweets table schema
with converted_raw_tweets as (
    select
        author_id,
        cast(created_at as timestamp) as created_at,
        edit_history_tweet_ids,
        id,
        lang,
        text,
        struct(
            cast(user.created_at as timestamp) as created_at,
            user.description,
            cast(user.id as string) as id,
            user.name,
            user.username
        ) as user,
        stream_rule
    from {{ ref('raw_tweets') }}
)

-- Specify the optimized schema for the converted raw_tweets table
select
    author_id::string,
    created_at::timestamp,
    edit_history_tweet_ids::string,
    id::string,
    lang::string,
    text::string,
    user::struct<
        created_at: timestamp,
        description: string,
        id: string,
        name: string,
        username: string
    >,
    stream_rule::string
from converted_raw_tweets
