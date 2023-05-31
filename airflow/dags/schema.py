schema = {
    "raw_tweets" : [
        {"name": "author_id", "type": "INTEGER", "mode": "NULLABLE"},
        {"name": "created_at", "type": "TIMESTAMP", "mode": "NULLABLE"},
        {"name": "edit_history_tweet_ids", "type": "INTEGER", "mode": "NULLABLE"},
        {"name": "id", "type": "INTEGER", "mode": "NULLABLE"},
        {"name": "lang", "type": "STRING", "mode": "NULLABLE"},
        {"name": "text", "type": "STRING", "mode": "NULLABLE"},
        {"name": "user", "type": "RECORD", "mode": "NULLABLE", "fields": [
            {"name": "created_at", "type": "STRING", "mode": "NULLABLE"},
            {"name": "description", "type": "STRING", "mode": "NULLABLE"},
            {"name": "id", "type": "INTEGER", "mode": "NULLABLE"},
            {"name": "name", "type": "STRING", "mode": "NULLABLE"},
            {"name": "username", "type": "STRING", "mode": "NULLABLE"}
        ]},
        {"name": "stream_rule", "type": "STRING", "mode": "NULLABLE"},
    ]
}