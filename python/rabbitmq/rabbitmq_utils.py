import json
import pika
from util.yamlConfig import read_config

config = read_config()
rabbitmq_config = config['rabbitmq']

RABBITMQ_HOST = rabbitmq_config['host']
RABBITMQ_USERNAME = rabbitmq_config['username']
RABBITMQ_PASSWORD = rabbitmq_config['password']
QUEUE_NAME = 'training_updates'

def send_to_rabbitmq(train_id, process_id, percentage, status, remaining_time):

    message_dict = {
        "TrainId": train_id,
        "ProcessID": process_id,
        "Percentage": f"{percentage:.2f}%",
        "Status": status,
        "RemainingTime": remaining_time
    }

    message_json = json.dumps(message_dict, ensure_ascii=False)

    try:
        credentials = pika.PlainCredentials(RABBITMQ_USERNAME, RABBITMQ_PASSWORD)
        connection = pika.BlockingConnection(pika.ConnectionParameters(host=RABBITMQ_HOST, credentials=credentials))
        channel = connection.channel()
        channel.queue_declare(queue=QUEUE_NAME, durable=True)

        channel.basic_publish(
            exchange='',
            routing_key=QUEUE_NAME,
            body=message_json,
            properties=pika.BasicProperties(delivery_mode=2)
        )
        connection.close()
    except pika.exceptions.AMQPConnectionError as e:
        print(f"Connection error: {e}")
    except pika.exceptions.ChannelWrongStateError as e:
        print(f"Channel error: {e}")
    print(f"发送 '{message_json}'")

def send_to_the_rabbitmq(queue_name, message):
    message_json = json.dumps(message, ensure_ascii=False)

    try:
        credentials = pika.PlainCredentials(RABBITMQ_USERNAME, RABBITMQ_PASSWORD)
        connection = pika.BlockingConnection(pika.ConnectionParameters(host=RABBITMQ_HOST, credentials=credentials))
        channel = connection.channel()
        channel.queue_declare(queue=queue_name, durable=True)

        channel.basic_publish(
            exchange='',
            routing_key=queue_name,
            body=message_json,
            properties=pika.BasicProperties(delivery_mode=2)
        )

        connection.close()
    except pika.exceptions.AMQPConnectionError as e:
        print(f"Connection error: {e}")
    except pika.exceptions.ChannelWrongStateError as e:
        print(f"Channel error: {e}")
    print(f"发送 '{message_json}'")

