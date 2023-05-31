INSERT INTO {{ BIGQUERY_DATASET }}.{{ RAW_TWEETS_TABLE }}
    (
        author_id,
        created_at,
        edit_history_tweet_ids,
        id,
        lang,
        text,
        user,
        stream_rule
    )
SELECT
    author_id,
    created_at,
    edit_history_tweet_ids,
    id,
    lang,
    text,
    STRUCT(
        created_at AS created_at,
        description AS description,
        id AS id,
        name AS name,
        username AS username
    ) AS user,
    stream_rule
FROM
    {{ BIGQUERY_DATASET }}.{{ RAW_TWEETS_TABLE}}_{{ logical_date.strftime("%Y%m%d%H") }}
