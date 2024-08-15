# Create Kind cluster
`kind create cluster --config ~/.kindconf/lsdmesp.conf`

# Create Ingress controller
`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml`

# Deploy Postgres
`cd ./demos/bin`
`./deploy_postgres.sh`

# Port-forward for Postgres
`kubectl port-forward svc/postgres 5432:5432 --namespace postgres`

# Startup Confluent MESP cluster
`cd ./confluent`
`./install.sh`

# Deploy Monolith app and Webapp, as well as scaled down Webapp 2, Webapp 3 and Microservice app
`cd ./demos/bin`
`./deploy_appmod.sh`

# Prep Army Knife for ksql cli
Exec into the Army Knife and start the KSQL CLI, but first create a properties file (/root/ksql.client.properties) with the following:
```
ssl.truststore.location=/root/lsdmesp.truststore.jks
ssl.truststore.password=112233
```

# Port-forward for Monolith
`kubectl port-forward svc/monolith-service 8000:8000 --namespace app-modernisation`

# Port-forward for Control Center
`kubectl port-forward controlcenter-0 9021:9021 --namespace lsdmesp-confluent`

# Add CFRBs
`cd ./demos/templates`
`kubectl apply -f 010-cf-additional-cfrb.yaml -n lsdmesp-confluent`

# Create topics
Create topics in CCC with user `peter`
```
postgres.bank.transactions
postgres.bank.accounts
postgres.bank.customers
express.bank.transactions
```

# Add transactions
Navigate to http://webapp.apps.mesp.lsdopen.io

Add the following transactions:
```
5208-0272-3184-5035:5
5188-6083-8011-0307:100
5188-6083-8011-0307:250
5188-6083-8011-0307:400
5588-6461-5550-9705:120
```

# Create source connector
Upload `postgres_source.json`
Show data in topics.

# Scale up Microservice deployment. Scale down webapp-mf1 and scale up webapp-mf2
```
kubectl scale deployment microservice-deployment -n app-modernisation --replicas=1
kubectl scale deployment webapp-mf1-deployment -n app-modernisation --replicas=0
kubectl scale deployment webapp-mf2-deployment -n app-modernisation --replicas=1
```

# Add additional port forwarding for microservice
```
kubectl port-forward svc/microservice-service 8001:8001 --namespace app-modernisation
```

# Add KSQL Streams
Start KSQL CLI:
`ksql --config-file /root/ksql.client.properties https://ksqldb:8088 -u peter -p peter-secret`
`SET 'auto.offset.reset' = 'earliest';`

```
CREATE STREAM postgres_bank_transactions WITH (KAFKA_TOPIC='postgres.bank.transactions', KEY_FORMAT ='AVRO', VALUE_FORMAT='AVRO');
SELECT * FROM postgres_bank_transactions EMIT CHANGES;
CREATE TABLE balances WITH (kafka_topic='balances') AS
    SELECT card_number, SUM(transaction_amount) AS balance
    FROM postgres_bank_transactions
    GROUP BY card_number
EMIT CHANGES;
SELECT * FROM balances EMIT CHANGES;
```

# Create some new transactions
```
5188-6083-8011-0307:99
5208-0272-3184-5035:140
5208-0272-3184-5035:410
5588-6461-5550-9705:118
5588-6461-5550-9705:203
```

# Part 3: setup

# Create a new stream for the transactions received from the "microservice"
```
CREATE STREAM express_bank_transactions (
  `key` VARCHAR KEY,
  `transaction_id` VARCHAR,
  `card_number` VARCHAR,
  `transaction_amount` INTEGER,
  `transaction_time` VARCHAR)
WITH (kafka_topic='express.bank.transactions', value_format='JSON');
```

# Create a new stream for sinking back to Postgres
```
CREATE STREAM jdbc_bank_transactions WITH (KAFKA_TOPIC='jdbc.bank.transactions', PARTITIONS=6, REPLICAS=3, VALUE_FORMAT='AVRO') AS
  SELECT `key`, `transaction_id`,`card_number`, `transaction_amount`, `transaction_time`
  FROM express_bank_transactions
EMIT CHANGES;
```

# Create a sink connector
Upload `postgres_sink.json`

# Cutover to using only microservice
```
kubectl scale deployment webapp-mf2-deployment -n app-modernisation --replicas=0
kubectl scale deployment webapp-mf3-deployment -n app-modernisation --replicas=1
kubectl scale deployment monolith-deployment -n app-modernisation --replicas=0
```

# Check port-forwarding

# Create some new transactions
```
5188-6083-8011-0307:2500
5208-0272-3184-5035:80
5588-6461-5550-9705:60
5588-6461-5550-9705:900
5588-6461-5550-9705:45
```

# Run queries in ksqlDB
```
SELECT * FROM express_bank_transactions EMIT CHANGES;
SELECT * FROM jdbc_bank_transactions EMIT CHANGES;
```

# Show data in database

# Demo Notification Service

## Create the advanced streams

- Copy ./streams/advanced-streams.ksql to the army knife and then run:

`http --verify=false --auth=peter:peter-secret POST https://ksqldb:8088/ksql ksql=@advanced-streams.ksql --check-status`

## Build and Push if there are any new changes to the app

```
cd apps/notification-service
mvn clean install -Pdocker
docker push lsdtrip/demo-notification-service
```

## Deploy

`kc apply -f kube/demo-notification-service-deployment.yaml`

## Clean-up

Undeploy app:

`kc delete -f kube/demo-notification-service-deployment.yaml`

From ksql drop streams and tables:

`ksql --config-file /root/ksql.client.properties https://ksqldb:8088 -u peter -p peter-secret`

```
drop stream jdbc_bank_transactions_enriched;
drop stream jdbc_bank_transactions_rekeyed;
drop table customers_accounts;
drop table accounts;
drop table customers;
drop stream accounts_stream;
drop stream customers_stream;
```

From army knife delete topics:

```
kafka-topics --delete --topic customers --bootstrap-server $LSDMESP_BOOTSTRAP_SERVERS --command-config /root/etc/client.properties
kafka-topics --delete --topic accounts --bootstrap-server $LSDMESP_BOOTSTRAP_SERVERS --command-config /root/etc/client.properties
kafka-topics --delete --topic customers_accounts --bootstrap-server $LSDMESP_BOOTSTRAP_SERVERS --command-config /root/etc/client.properties
kafka-topics --delete --topic jdbc_bank_transactions_rekeyed --bootstrap-server $LSDMESP_BOOTSTRAP_SERVERS --command-config /root/etc/client.properties
kafka-topics --delete --topic jdbc_bank_transactions_enriched --bootstrap-server $LSDMESP_BOOTSTRAP_SERVERS --command-config /root/etc/client.properties
```
