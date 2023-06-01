{{ config(materialized='view') }}

-- Convert raw_tweets table schema and cast columns to desired types
WITH converted_raw_tweets AS (
    SELECT
        CAST(author_id AS INT64) AS author_id,
        CAST(created_at AS TIMESTAMP) AS created_at,
        CAST(edit_history_tweet_ids AS STRING) AS edit_history_tweet_ids,
        CAST(id AS INT64) AS id,
        CAST(lang AS STRING) AS lang,
        CAST(text AS STRING) AS text,
        STRUCT(
            CAST(user.created_at AS TIMESTAMP) AS created_at,
            CAST(user.description AS STRING) AS description,
            CAST(user.id AS INT64) AS id,
            CAST(user.name AS STRING) AS name,
            CAST(user.username AS STRING) AS username
        ) AS user,
        CAST(stream_rule AS STRING) AS stream_rule
    FROM {{ source('staging', 'raw_tweets') }}
)

-- Select the converted columns
SELECT
    author_id,
    created_at,
    edit_history_tweet_ids,
    id,
    lang,
    text,
    user,
    stream_rule
FROM converted_raw_tweets