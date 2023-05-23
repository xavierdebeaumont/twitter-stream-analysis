# Use an official Python runtime as a parent image
FROM python:3.10.6-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Update package repositories and install telnet
RUN apt-get update && apt-get install -y telnet

# Run app.py when the container launches
ENTRYPOINT ["python", "./producer.py"]