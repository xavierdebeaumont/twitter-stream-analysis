from pyspark.sql.types import (IntegerType,
                               StringType,
                               DoubleType,
                               StructField,
                               StructType,
                               LongType,
                               BooleanType)

schema = {
    'raw_tweets' : StructType([
    StructField("author_id", LongType(), True),
    StructField("created_at", StringType(), True),
    StructField("edit_history_tweet_ids", LongType(), True),
    StructField("id", LongType(), True),
    StructField("lang", StringType(), True),
    StructField("text", StringType(), True),
    StructField("user", StructType([
        StructField("created_at", StringType(), True),
        StructField("description", StringType(), True),
        StructField("id", LongType(), True),
        StructField("name", StringType(), True),
        StructField("username", StringType(), True)
    ]), True),
    StructField("stream_rule", StringType(), True)
])
}