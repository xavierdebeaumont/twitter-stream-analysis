## Setup Airflow VM

We will setup airflow on docker in a dedicated compute instance. dbt is setup inside airflow.

- Establish SSH connection

  ```bash
  ssh twitter-streaming-airflow
  ```

- Clone git repo

  ```bash
  git clone https://github.com/xavierdebeaumont/twitter_stream_analysis.git && \
  cd twitter_stream_analysis
  ```
- Install anaconda, docker & docker-compose.

  ```bash
  bash ~/twitter_stream_analysis/scripts/vm_setup.sh && \
  exec newgrp docker
  ```
- Connect to gcloud via the cli.

    ```bash
    gcloud init
    ```

- Set the file to be readable.

    ```bash
    sudo chmod a+r ~/.google/credentials/google_credentials.json
    ```

- Set the evironment variables (same as Terraform values)-

  - GCP Project ID

  - Cloud Storage Bucket Name

    ```bash
    export GCP_PROJECT_ID=project-id
    export GCP_GCS_BUCKET=bucket-name
    ```

    **Note**: You will have to setup these env vars every time you create a new shell session.

- Start Airflow.

  ```bash
  bash ~/twitter_stream_analysis/scripts/airflow_startup.sh && cd ~/twitter_stream_analysis/airflow
  ```

- Airflow should be available on port `8080` a couple of minutes after the above setup is complete. Login with default username & password as **airflow**.

- Airflow will be running in detached mode. To see the logs from docker run the below command

  ```bash
  docker-compose logs --follow
  ```

- To stop airflow

  ```bash
  docker-compose down
  ```