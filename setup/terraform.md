## Terraform Infra Setup

Clone the repository in your local machine.

```bash
git clone https://github.com/xavierdebeaumont/twitter_stream_analysis.git && \
cd twitter_stream_analysis/terraform
```

Spin up the Infra -

- Initiate terraform and download the required dependencies-

  ```bash
  terraform init
  ```

- View the Terraform plan

  You will be asked to enter two values, the name of the GCS bucket you want to create and your GCP Project ID. Use the same values throughout the project. 

  ```bash
  terraform plan
  ```

- Terraform plan should show the creation of following services -

  - `e2-standard-4` Compute Instance for Kafka
  - `e2-standard-4` Compute Instance for Airflow
  - Dataproc Spark Cluster
    - One `e2-standard-2` Master node
    - Two `e2-medium` Worker nodes
  - A Google Cloud Storage bucket
  - Two Bigquery Datasets
    - twitter-streaming_stg
    - twitter-streaming_prod
  - Firewall rule to open port `9092` on the Kafka Instance

- Apply the infra. **Note** - Billing will start as soon as the apply is complete.

  ```bash
  terraform apply
  ```

- Once you are done with the project. Teardown the infra using-

  ```bash
  terraform destroy
  ```