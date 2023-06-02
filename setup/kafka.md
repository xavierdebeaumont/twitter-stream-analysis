## Setup Kafka VM

We will setup Kafka and twitter stream in two separate docker processes in a dedicated compute instance. The twitter stream will communicate with port `9092` of the `broker` container of Kafka to send events.

- Establish SSH connection

  ```bash
  ssh streaming-kafka-instance
  ```

- Clone git repo and cd into Kafka folder

  ```bash
  git clone https://github.com/xavierdebeaumont/twitter_stream_analysis.git
  ```

- Install docker & docker-compose

  ```bash
  bash ~/twitter_stream_analysis/scripts/vm_setup.sh && \
  exec newgrp docker
  ```

- Setup Kafka Address
  ```bash
  export KAFKA_ADDRESS= "<your-kafka-address>"
  ```
  **Note**: You will have to setup these env vars every time you create a new shell session. Or if you stop/start your VM

- Start Kafka 

  ```bash
  cd ~/twitter_stream_analysis/kafka && \
  docker-compose build && \
  docker-compose up 
  ```

- Open another terminal session for the Kafka VM and start sending messages to your Kafka broker with the producer.

- Build the docker image and run it
  ```bash
  exec newgrp docker
  cd ~/twitter_stream_analysis/producer && \
  docker build -t twitter-stream:1.0 . && \
  docker run -e KAFKA_ADDRESS=$KAFKA_ADDRESS \
    -itd \
    --name twitter-stream \
    --network kafka-stream-network \
    twitter-stream:1.0 \
        --bearer_token "<your-bearer-token>" \
        --topic_id raw_tweets \
        --stream_rule "<your-stream-rule>"
  ```

    This will start creating events for 1 Million users spread out from the current time to the next 24 hours. 
  The container will run in detached mode. Follow the logs to see the progress.

- To follow the logs

  ```bash
  docker logs --follow twitter-stream
  ```

    You should see one topic, your topic_id

- To stop the running docker

  ```bash
  docker stop twitter-stream
  ```