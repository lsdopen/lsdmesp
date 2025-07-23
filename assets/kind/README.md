## To use local registry for Kind

## TBC: Instructions to do this.
## See attached config and shell script.

## After the local registry is working for Kind, you can do the following (for Strimzi 0.46.1 and Kafka 4.0.0 and CP 8.0.0)
docker pull lsdopen/kafka-army-knife:latest
docker pull quay.io/strimzi/operator:0.46.1
docker pull quay.io/strimzi/kafka:0.46.1-kafka-4.0.0
docker pull quay.io/strimzi/kafka-bridge:0.32.0
docker pull lsdtrip/cp-kafka-connect:8.0.0
docker pull confluentinc/cp-schema-registry:8.0.0
docker pull confluentinc/cp-kafka-rest:8.0.0
docker pull confluentinc/cp-ksqldb-server:8.0.0
docker pull lsdtrip/kafka-connect:0.46.1-kafka-4.0.0
docker pull ghcr.io/kafbat/kafka-ui:v1.2.0

docker tag lsdopen/kafka-army-knife:latest localhost:5001/lsdopen/kafka-army-knife:latest
docker tag quay.io/strimzi/operator:0.46.1 localhost:5001/strimzi/operator:0.46.1
docker tag quay.io/strimzi/kafka:0.46.1-kafka-4.0.0 localhost:5001/strimzi/kafka:0.46.1-kafka-4.0.0
docker tag quay.io/strimzi/kafka-bridge:0.32.0 localhost:5001/strimzi/kafka-bridge:0.32.0
docker tag lsdtrip/cp-kafka-connect:8.0.0 localhost:5001/lsdtrip/cp-kafka-connect:8.0.0
docker tag confluentinc/cp-schema-registry:8.0.0 localhost:5001/confluentinc/cp-schema-registry:8.0.0
docker tag confluentinc/cp-kafka-rest:8.0.0 localhost:5001/confluentinc/cp-kafka-rest:8.0.0
docker tag confluentinc/cp-ksqldb-server:8.0.0 localhost:5001/confluentinc/cp-ksqldb-server:8.0.0
docker tag lsdtrip/kafka-connect:0.46.1-kafka-4.0.0 localhost:5001/lsdtrip/kafka-connect:0.46.1-kafka-4.0.0
docker tag ghcr.io/kafbat/kafka-ui:v1.2.0 localhost:5001/kafbat/kafka-ui:v1.2.0

docker push localhost:5001/lsdopen/kafka-army-knife:latest
docker push localhost:5001/strimzi/operator:0.46.1
docker push localhost:5001/strimzi/kafka:0.46.1-kafka-4.0.0
docker push localhost:5001/strimzi/kafka-bridge:0.32.0
docker push localhost:5001/lsdtrip/cp-kafka-connect:8.0.0
docker push localhost:5001/confluentinc/cp-schema-registry:8.0.0
docker push localhost:5001/confluentinc/cp-kafka-rest:8.0.0
docker push localhost:5001/confluentinc/cp-ksqldb-server:8.0.0
docker push localhost:5001/lsdtrip/kafka-connect:0.46.1-kafka-4.0.0
docker push localhost:5001/kafbat/kafka-ui:v1.2.0

## After the local registry is working for Kind, you can do the following (for CfK 3.0.0 and CP 8.0.0)
docker pull lsdopen/kafka-army-knife:latest
docker pull confluentinc/confluent-operator:0.1263.8
docker pull confluentinc/confluent-init-container:3.0.0
docker pull confluentinc/cp-server:8.0.0
docker pull confluentinc/cp-server-connect:8.0.0
docker pull confluentinc/cp-schema-registry:8.0.0
docker pull confluentinc/cp-kafka-rest:8.0.0
docker pull confluentinc/cp-ksqldb-server:8.0.0
docker pull confluentinc/cp-enterprise-control-center-next-gen:2.2.0
docker pull confluentinc/confluent-cli:latest
docker pull lsdtrip/kafka-lag-exporter:latest
docker pull osixia/openldap:1.5.0

docker tag lsdopen/kafka-army-knife:latest localhost:5001/lsdopen/kafka-army-knife:latest
docker tag confluentinc/confluent-operator:0.1263.8 localhost:5001/confluentinc/confluent-operator:0.1263.8
docker tag confluentinc/confluent-init-container:3.0.0 localhost:5001/confluentinc/confluent-init-container:3.0.0
docker tag confluentinc/cp-server:8.0.0 localhost:5001/confluentinc/cp-server:8.0.0
docker tag confluentinc/cp-server-connect:8.0.0 localhost:5001/confluentinc/cp-server-connect:8.0.0
docker tag confluentinc/cp-schema-registry:8.0.0 localhost:5001/confluentinc/cp-schema-registry:8.0.0
docker tag confluentinc/cp-kafka-rest:8.0.0 localhost:5001/confluentinc/cp-kafka-rest:8.0.0
docker tag confluentinc/cp-ksqldb-server:8.0.0 localhost:5001/confluentinc/cp-ksqldb-server:8.0.0
docker tag confluentinc/cp-enterprise-control-center-next-gen:2.2.0 localhost:5001/confluentinc/cp-enterprise-control-center-next-gen:2.2.0
docker tag confluentinc/confluent-cli:latest localhost:5001/confluentinc/confluent-cli:latest
docker tag lsdtrip/kafka-lag-exporter:latest localhost:5001/lsdtrip/kafka-lag-exporter:latest
docker tag osixia/openldap:1.5.0 localhost:5001/osixia/openldap:1.5.0

docker push localhost:5001/lsdopen/kafka-army-knife:latest
docker push localhost:5001/confluentinc/confluent-operator:0.1263.8
docker push localhost:5001/confluentinc/confluent-init-container:3.0.0
docker push localhost:5001/confluentinc/cp-server:8.0.0
docker push localhost:5001/confluentinc/cp-server-connect:8.0.0
docker push localhost:5001/confluentinc/cp-schema-registry:8.0.0
docker push localhost:5001/confluentinc/cp-kafka-rest:8.0.0
docker push localhost:5001/confluentinc/cp-ksqldb-server:8.0.0
docker push localhost:5001/confluentinc/cp-enterprise-control-center-next-gen:2.2.0
docker push localhost:5001/confluentinc/confluent-cli:latest
docker push localhost:5001/lsdtrip/kafka-lag-exporter:latest
docker push localhost:5001/osixia/openldap:1.5.0
