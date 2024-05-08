#!/bin/bash

confluent login --url https://kafka:8090 --ca-cert-path /opt/ca.pem

CLUSTER_ID=$(confluent cluster describe --url https://kafka:8090 --ca-cert-path /opt/ca.pem | grep kafka-cluster | awk '{print $3}')
SCHEMA_REGISTRY_CLUSTER="id_schemaregistry_lsdmesp-confluent"
SUBJECT="example-topic-value"
TOPICS='example-topic'

for topic in $TOPICS; do
  echo "Adding role ResourceOwner for topic $topic"
  confluent iam rbac role-binding create --principal Group:support --role ResourceOwner --resource Topic:"$topic" --kafka-cluster "$CLUSTER_ID"
done

echo "giving developer read for groups and developer write for transaction id's"
confluent iam rbac role-binding create --principal Group:support --role DeveloperRead --resource Group:basic- --prefix --kafka-cluster "$CLUSTER_ID"
confluent iam rbac role-binding create --principal Group:support --role DeveloperRead --resource Group:example- --prefix --kafka-cluster "$CLUSTER_ID"
confluent iam rbac role-binding create --principal Group:support --role DeveloperWrite --resource TransactionalId:basic- --prefix --kafka-cluster "$CLUSTER_ID"
confluent iam rbac role-binding create --principal Group:support --role DeveloperWrite --resource TransactionalId:tx- --prefix --kafka-cluster "$CLUSTER_ID"

confluent iam rbac role-binding create \
  --principal Group:support \
  --role ResourceOwner \
  --resource Subject:"$SUBJECT" \
  --kafka-cluster "$CLUSTER_ID" \
  --schema-registry-cluster "$SCHEMA_REGISTRY_CLUSTER"

echo "Done!"
