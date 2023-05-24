import argparse
import json
from confluent_kafka import Producer
import tweepy
import os 



def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument('--bearer_token', type=str, required=True)
    parser.add_argument('--stream_rule', type=str, required=True)
    parser.add_argument('--topic_id', type=str, required=True)

    return parser.parse_args()

# Kafka configuration
KAFKA_ADDRESS = os.getenv('KAFKA_ADDRESS')
kafka_bootstrap_servers = f'{KAFKA_ADDRESS}:9092'

def write_to_kafka(data, producer, stream_rule, kafka_topic):
    data["stream_rule"] = stream_rule
    data_formatted = json.dumps(data).encode("UTF-8")
    print(data_formatted)
    producer.produce(kafka_topic, data_formatted)
    producer.flush()

# Custom StreamListener class to process tweets and send to Kafka
class KafkaStreamListener(tweepy.StreamingClient):
    def __init__(self, kafka_topic, bearer_token, stream_rule):
        super().__init__(bearer_token)
        self.kafka_topic = kafka_topic
        self.producer = Producer({'bootstrap.servers': kafka_bootstrap_servers})
        self.stream_rule = stream_rule

    def on_response(self, response):
        tweet_data = response.data.data

        user_data = response.includes['users'][0].data
        result = tweet_data
        result["user"] = user_data

        write_to_kafka(result, self.producer, self.stream_rule, self.kafka_topic)

    def on_error(self, status):
        print('Twitter API error:', status)

if __name__ =="__main__":
    tweet_fields = ['id', 'text', 'author_id', 'created_at', 'lang']
    user_fields = ['description', 'created_at', 'location']
    expansions = ['author_id']

    args = parse_args()
    stream_listener = KafkaStreamListener(args.topic_id, args.bearer_token, args.stream_rule)
    print(args.topic_id + '\n')

    print(args.stream_rule)

    rules = stream_listener.get_rules().data
    if rules is not None:
        existing_rules = [rule.id for rule in stream_listener.get_rules().data]
        stream_listener.delete_rules(ids=existing_rules)

    stream_listener.add_rules(tweepy.StreamRule(args.stream_rule))
    print(stream_listener.get_rules().data)
    stream_listener.filter(tweet_fields=tweet_fields, expansions=expansions, user_fields=user_fields)