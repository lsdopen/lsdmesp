## Testing

### Clone Blueprints Repository and Prep Army Knife

```
> git clone git@github.com:lsdopen/kafka-blueprints.git
> cd kafka-blueprints
> mvn clean install
```

And then copy the whole of kafka-blueprints to the army knife /root.

```
> kubectl cp kafka-blueprints `kubectl get pods | grep army | awk '{print $1}'`:/root
```

Further, **inside** the army knife make a **copy** of the read-only mounted client.properties file:

> cp /root/etc/client.properties /root/client.properties

And **replace** the existing user details with peter:peter-secret.

### REST Proxy Testing

Create topic with enough replicas:

> kafka-topics --create --topic prod.teamblue.rest.topic --bootstrap-server $LSDMESP_BOOTSTRAP_SERVERS --partitions 6 --replication-factor 3 --command-config /root/etc/client.properties

#### Example produce REST test

```
> cd /root/kafka-blueprints/kafka-restproxy-blueprint
> python3 produce.py
```

#### Example consume REST test

```
> cd /root/kafka-blueprints/kafka-restproxy-blueprint
> python3 consume.py
```

#### Example produce REST with schemas test

Avro Schema:

```
curl -k -u "peter:peter-secret" -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" -H "Accept: application/vnd.kafka.v2+json" --data '{"value_schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"name\", \"type\": \"string\"}]}", "records": [{"value": {"name": "testUser"}}]}' "https://kafkarestproxy:8082/topics/prod.teamblue.rest.topic"
curl -k -u "peter:peter-secret" -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" -H "Accept: application/vnd.kafka.v2+json" --data '{"value_schema_id": 1, "records": [{"value": {"name": "testUser2"}}]}' "https://kafkarestproxy:8082/topics/prod.teamblue.rest.topic"
```

JSON Schema:
```
curl -k -u "peter:peter-secret" -X POST -H "Content-Type: application/vnd.kafka.jsonschema.v2+json" -H "Accept: application/vnd.kafka.v2+json" --data '{"value_schema": "{\"type\":\"object\",\"properties\":{\"name\":{\"type\":\"string\"}}}", "records": [{"value": {"name": "testUser"}}]}' "https://kafkarestproxy:8082/topics/prod.teamblue.rest2.topic"
curl -k -u "peter:peter-secret" -X POST -H "Content-Type: application/vnd.kafka.jsonschema.v2+json" -H "Accept: application/vnd.kafka.v2+json" --data '{"value_schema_id": 2, "records": [{"value": {"name": "testUser2"}}]}' "https://kafkarestproxy:8082/topics/prod.teamblue.rest2.topic"
```

### Ordering and Duplication tests

Create topic with 1 partition only for ordering:

> kafka-topics --create --topic prod.teamblue.ordering.topic --bootstrap-server $LSDMESP_BOOTSTRAP_SERVERS --partitions 1 --replication-factor 3 --command-config /root/etc/client.properties

Produce a fixed sequence of events:

```
> cd /root/kafka-blueprints/kafka-idempotent-producer-blueprint/target
> java -jar kafka-idempotent-producer-blueprint-1.0.0-SNAPSHOT.jar --bootstrap-servers $LSDMESP_BOOTSTRAP_SERVERS --schema-registry-url $LSDMESP_SCHEMA_REGISTRY_URL --target-topic prod.teamblue.ordering.topic --start-id "1000" --num-events "20000000" --command-config /root/client.properties
```

Then check that the sequence is correct, in either case:

```
> cd /root/kafka-blueprints/kafka-idempotent-consumer-blueprint/target
> java -jar kafka-idempotent-consumer-blueprint-1.0.0-SNAPSHOT.jar --bootstrap-servers $LSDMESP_BOOTSTRAP_SERVERS --schema-registry-url $LSDMESP_SCHEMA_REGISTRY_URL --source-topic prod.teamblue.ordering.topic --seek-to-beginning --max-idle-millis "10000" --expected-start-id "1000" --expected-end-id "20000999" --command-config /root/client.properties
```

### Connect testing

See connector json file:
> kafka-blueprints/kafka-connector-blueprints/prod_teamblue_datagen_conn.json

### KSQL Testing

See stream sql file:
> kafka-blueprints/kafka-ksqldb-blueprints/prod_teamblue_datagen_stream.sql
