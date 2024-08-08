## Testing

### REST Proxy Testing

Create topic with enough replicas:

> kafka-topics --create --topic bets-rest-topic --bootstrap-server $LSDMESP_BOOTSTRAP_SERVERS --partitions 6 --replication-factor 3 --command-config /root/etc/client.properties

#### Example produce REST test

```
- cd ~/betsoftware-confluent/betsoftware-blueprints/betsoftware-restproxy-blueprint
- python3 produce.py
```

#### Example consume REST test

```
- cd ~/betsoftware-confluent/betsoftware-blueprints/betsoftware-restproxy-blueprint
- python3 produce.py
```

### Ordering and Duplication tests

Create topic with 1 partition only for ordering:

> kafka-topics --create --topic bets-ordering-topic --bootstrap-server $LSDMESP_BOOTSTRAP_SERVERS --partitions 1 --replication-factor 3 --command-config /root/etc/client.properties

Produce a fixed sequence of events:

```
- cd ~/betsoftware-confluent/betsoftware-blueprints/betsoftware-producer-blueprint/target
- java -jar betsoftware-producer-blueprint-1.0.0-SNAPSHOT.jar --bootstrap-servers $LSDMESP_BOOTSTRAP_SERVERS --schema-registry-url $LSDMESP_SCHEMA_REGISTRY_URL --target-topic bets-ordering-topic --start-id "1000" --num-events "20000000" --command-config /root/etc/client.properties
```

Then check that the sequence is correct, in either case:

```
- cd ~/betsoftware-confluent/betsoftware-blueprints/betsoftware-consumer-blueprint/target
- java -jar betsoftware-consumer-blueprint-1.0.0-SNAPSHOT.jar --bootstrap-servers $LSDMESP_BOOTSTRAP_SERVERS --schema-registry-url $LSDMESP_SCHEMA_REGISTRY_URL --source-topic bets-ordering-topic --seek-to-beginning --max-idle-millis "10000" --expected-start-id "1000" --expected-end-id "20000999" --command-config /root/etc/client.properties
```

### Connect testing

See connector json file in this folder.

### KSQL Testing

See stream sql file in this folder.
