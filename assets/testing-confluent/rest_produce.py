import requests
import json
import sys

POST_HEADERS = {"Content-Type": "application/vnd.kafka.json.v2+json"}

USERNAME = "cf_kafka"
PASSWORD = "(2FbgWk3Kj{L"
CA_FILE = '/root/certs/ca.pem'


def main(argv):
    rest_proxy_url = "https://kafkarestproxy:8082"
    topic_name = "bets-rest-topic"

    url = f'{rest_proxy_url}/topics/{topic_name}'

    print("Producing to url and topic", url, topic_name)

    for id in range(100):
        payload = {"records": [{
            "key": "key-" + str(id),
            "value": "user-" + str(id)
        }]}
        r = requests.post(url, auth=(USERNAME, PASSWORD), data=json.dumps(payload), headers=POST_HEADERS, verify=CA_FILE)

        print("Produced [" + str(payload) + "] with response: " + str(r.status_code))
        if r.status_code != 200:
            print(r.text)
            break


# Entrypoint
if '__main__' == __name__:
    sys.exit(main(sys.argv))

