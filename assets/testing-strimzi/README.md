## Testing

### Basic army knife testing:

List all topics using the internal listener from within the army knife:

> kafka-topics --list --bootstrap-server lsdmesp-kafka-bootstrap:9092

### Testing from the 'outside' using the nodeports

Find out where the brokers are running:

> kc get pods -owide | grep lsdmesp-broker

And then find the worker node details (for kind clusters):

> kc get nodes -owide | grep kind-worker

Then match up the brokers to find the IPs and fix the /etc/hosts entries, e.g:

```
172.22.0.2  broker0.mesp.lsdopen.io
172.22.0.5  broker1.mesp.lsdopen.io
172.22.0.4  broker2.mesp.lsdopen.io
```

Use the helper scripts to create the keystores and the property files:

```
cd assets/testing-strimzi/scripts/bin
./get_user_certs.sh lsdadmin
./create_client_properties.sh lsdadmin
```

Finally connect to the nodeport port for any of the brokers:

> kafka-topics --list --bootstrap-server broker0.mesp.lsdopen.io:32100 --command-config ../config/lsdadmin.properties

### Create connector

```
curl -X POST \
  http://lsdmesp-connect-api:8083/connectors \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "prod.teamblue.datagen.conn",
  "config": {
    "value.converter.schema.registry.url": "http://lsdmesp-cp-schema-registry:8081",
    "name": "prod.teamblue.datagen.conn",
    "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "kafka.topic": "prod.teamblue.datagen.topic",
    "quickstart": "users"
  }
}'
```

### List streams:

```
curl -X "POST" "http://lsdmesp-cp-ksql-server:8088/ksql" \
-H "Accept: application/vnd.ksql.v1+json" \
-d $'{
"ksql": "LIST STREAMS;",
"streamsProperties": {}
}'
```

Show topics:

```
curl -X "POST" "http://lsdmesp-cp-ksql-server:8088/ksql" \
-H "Accept: application/vnd.ksql.v1+json" \
-d $'{
"ksql": "show topics;",
"streamsProperties": {}
}'
```

### Create streams:

```
curl -X "POST" "http://lsdmesp-cp-ksql-server:8088/ksql" \
-H "Accept: application/vnd.ksql.v1+json" \
-H "Content-Type: application/vnd.ksql.v1+json" \
-d $'{
"ksql":"CREATE STREAM prod_teamblue_datagen_stream WITH (KAFKA_TOPIC='"'"'prod.teamblue.datagen.topic'"'"', VALUE_FORMAT='"'"'AVRO'"'"');",
"streamsProperties": {
"ksql.streams.auto.offset.reset": "earliest"
}
}'
```

And the copy stream:

```
curl -X "POST" "http://lsdmesp-cp-ksql-server:8088/ksql" \
-H "Accept: application/vnd.ksql.v1+json" \
-H "Content-Type: application/vnd.ksql.v1+json" \
-d $'{
"ksql":"CREATE STREAM prod_teamblue_datagen_stream_copy WITH (KAFKA_TOPIC='"'"'prod.teamblue.datagen.topic.copy'"'"', PARTITIONS=6, REPLICAS=3) AS  SELECT * FROM prod_teamblue_datagen_stream EMIT CHANGES;",
"streamsProperties": {
"ksql.streams.auto.offset.reset": "earliest"
}
}'
```

### Describe Stream

```
curl -X "POST" "http://lsdmesp-cp-ksql-server:8088/ksql" \
-H "Accept: application/vnd.ksql.v1+json" \
-d $'{
"ksql": "describe prod_teamblue_datagen_stream_copy;",
"streamsProperties": {}
}'
```
