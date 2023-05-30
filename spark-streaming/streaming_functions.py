from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col, month, hour, dayofmonth, col, year, udf, to_timestamp

@udf
def string_decode(s, encoding='utf-8'):
    if s:
        return (s.encode('latin1')         # To bytes, required by 'unicode-escape'
                .decode('unicode-escape') # Perform the actual octal-escaping decode
                .encode('latin1')         # 1:1 mapping back to bytes
                .decode(encoding)         # Decode original encoding
                .strip('\"'))

    else:
        return s

def get_or_create_spark_session(app_name, master="yarn"):
    """
    Creates or gets a Spark Session

    Parameters:
        app_name : str
            Pass the name of your app
        master : str
            Choosing the Spark master, yarn is the default
    Returns:
        spark: SparkSession
    """
    spark = (SparkSession
             .builder
             .appName(app_name)
             .master(master=master)
             .getOrCreate())

    return spark

def create_kafka_read_stream(spark, kafka_address, kafka_port, topic, starting_offset="earliest"):
    """
    Creates a kafka read stream

    Parameters:
        spark : SparkSession
            A SparkSession object
        kafka_address: str
            Host address of the kafka bootstrap server
        topic : str
            Name of the kafka topic
        starting_offset: str
            Starting offset configuration, "earliest" by default 
    Returns:
        read_stream: DataStreamReader
    """

    read_stream = (spark
                   .readStream
                   .format("kafka")
                   .option("kafka.bootstrap.servers", f"{kafka_address}:{kafka_port}")
                   .option("failOnDataLoss", False)
                   .option("startingOffsets", starting_offset)
                   .option("subscribe", topic)
                   .load())

    return read_stream

def process_stream(stream, stream_schema, topic):
    """
    Process stream to fetch on value from the kafka message.
    convert created_at to timestamp format and produce year, month, day,
    hour columns
    Parameters:
        stream : DataStreamReader
            The data stream reader for your stream
    Returns:
        stream: DataStreamReader
    """

    # read only value from the incoming message and convert the contents
    # inside to the passed schema
    stream = (stream
              .selectExpr("CAST(value AS STRING)")
              .select(
                  from_json(col("value"), stream_schema).alias(
                      "data")
              )
              .select("data.*")
              )

    # Add month, day, hour to split the data into separate directories
    stream = (stream
            .withColumn("created_at", to_timestamp(col("created_at"), "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
            )


    # # rectify string encoding
    # stream = (stream
    #             .withColumn("text", string_decode("text"))
    # )

    return stream


def create_file_write_stream(stream, storage_path, checkpoint_path, trigger="120 seconds", output_mode="append", file_format="parquet"):
    """
    Write the stream back to a file store

    Parameters:
        stream : DataStreamReader
            The data stream reader for your stream
        file_format : str
            parquet, csv, orc etc
        storage_path : str
            The file output path
        checkpoint_path : str
            The checkpoint location for spark
        trigger : str
            The trigger interval
        output_mode : str
            append, complete, update
    """

    write_stream = (stream
                    .writeStream
                    .format(file_format)
                    .partitionBy("year", "month", "day", "hour")
                    .option("path", storage_path)
                    .option("checkpointLocation", checkpoint_path)
                    .trigger(processingTime=trigger)
                    .outputMode(output_mode))

    return write_stream