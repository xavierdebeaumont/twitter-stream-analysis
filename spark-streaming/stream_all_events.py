import os
from streaming_functions import *
from schema import schema

# Kafka Topics
RAW_TWEETS_TOPIC = "twitter_stream"

KAFKA_PORT = "9092"

KAFKA_ADDRESS = os.getenv("KAFKA_ADDRESS", 'localhost')
GCP_GCS_BUCKET = os.getenv("GCP_GCS_BUCKET")
GCS_STORAGE_PATH = f'gs://{GCP_GCS_BUCKET}'

# initialize a spark session
spark = get_or_create_spark_session('Twitter Analysis')
spark.streams.resetTerminated()

# listen events stream
raw_tweets = create_kafka_read_stream(
    spark, KAFKA_ADDRESS, KAFKA_PORT, RAW_TWEETS_TOPIC)
raw_tweets = process_stream(
    raw_tweets, schema["raw_tweets"], RAW_TWEETS_TOPIC)

# write a file to storage every 2 minutes in parquet format
raw_tweets_writer = create_file_write_stream(raw_tweets,
                                                f"{GCS_STORAGE_PATH}/{RAW_TWEETS_TOPIC}",
                                                f"{GCS_STORAGE_PATH}/checkpoint/{RAW_TWEETS_TOPIC}"
                                                )

raw_tweets_writer.start()
spark.streams.awaitAnyTermination()