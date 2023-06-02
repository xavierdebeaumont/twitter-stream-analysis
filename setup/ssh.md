## VM SSH Setup

- I recommend watching  [this video by Alexey](https://www.youtube.com/watch?v=ae-CV2KfoN0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb).

- Create an ssh key in your local system in the `.ssh` folder - [Guide](https://cloud.google.com/compute/docs/connect/create-ssh-keys#linux-and-macos)

- Add the public key (`.pub`) to your VM instance - [Guide](https://cloud.google.com/compute/docs/connect/add-ssh-keys#expandable-2)

- Create a config file in your `.ssh` folder

  ```bash
  touch ~/.ssh/config
  ```

- Copy the following snippet and replace with External IP of the Kafka, Spark (Master Node), Airflow VMs. Username and path to the ssh private key

    ```bash
    Host streaming-kafka-instance
        HostName <External IP Address>
        User <username>
        IdentityFile <path/to/home/.ssh/keyfile>

    Host streaming-spark-instance
        HostName <External IP Address Of Master Node>
        User <username>
        IdentityFile <path/to/home/.ssh/keyfile>

    Host twitter-streaming-airflow
        HostName <External IP Address>
        User <username>
        IdentityFile <path/to/home/.ssh/gcp>
    ```

- Once you are setup, you can simply SSH into the servers using the below commands in separate terminals. Do not forget to change the IP address of VM restarts.

    ```bash
    ssh streaming-kafka-instance
    ```

    ```bash
    ssh streaming-spark-instance
    ```

    ```bash
    ssh twitter-streaming-airflow
    ```

- You will have to forward ports from your VM to your local machine for you to be able to see Kafka, Airflow UI. Check how to do that [here](https://youtu.be/ae-CV2KfoN0?t=1074)
