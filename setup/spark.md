We will start the Spark Streaming process in the DataProc cluster we created to communicate with the Kafka VM instance over the port `9092`. Remember, we opened port 9092 for it to be able to accept connections.

- Establish SSH connection to the **master node**

  ```bash
  ssh streamify-spark
  ```

- Clone git repo

  ```bash
  git clone https://github.com/xavierdebeaumont/twitter_stream_analysis.git
  cd twitter_stream_analysis/spark-streaming
  ```

- Set the environment variables -

  - External IP of the Kafka VM so that spark can connect to it

  - Name of your GCS bucket. (What you gave during the terraform setup)

    ```bash
    export KAFKA_ADDRESS=IP.ADD.RE.SS
    export GCP_GCS_BUCKET=bucket-name
    ```

     **Note**: You will have to setup these env vars every time you create a new shell session. Or if you stop/start your cluster

- Start reading messages

  ```bash
  spark-submit \
  --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.3 \
  spark-streaming/stream_all_events.py
  ```