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
        user.created_at AS created_at,
        user.description AS description,
        user.id AS id,
        user.name AS name,
        user.username AS username
    ) AS user,
    stream_rule
FROM
    {{ BIGQUERY_DATASET }}.{{ RAW_TWEETS_TABLE}}_{{ logical_date.strftime("%Y%m%d%H") }}
