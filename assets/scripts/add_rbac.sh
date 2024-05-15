#!/bin/bash

#
# 1) kubectl apply -f confluent-cli.yaml
# 2) kubectl get secret ca-pair-sslcerts -ojson | jq -r '.data."tls.crt"' | base64 -d > ca.pem
# 3) kubectl cp ca.pem confluent-cli:/opt
# 4) kubectl exec -it confluent-cli bash
#

confluent login --url https://kafka:8090 --ca-cert-path /opt/ca.pem

CLUSTER_ID=$(confluent cluster describe --url https://kafka:8090 --ca-cert-path /opt/ca.pem | grep kafka-cluster | awk '{print $3}')
SCHEMA_REGISTRY_CLUSTER="id_schemaregistry_lsdmesp-confluent"
CONNECT_CLUSTER_ID=lsdmesp-confluent.connect
KSQL_SERVICE_ID=lsdmesp-confluent.ksqldb_

confluent iam rbac role-binding create --principal Group:TeamBlueRead --role DeveloperRead --resource Topic:prod.teamblue. --prefix --kafka-cluster "$CLUSTER_ID"
confluent iam rbac role-binding create --principal Group:TeamBlueRead --role DeveloperRead --resource Group:prod.teamblue. --prefix --kafka-cluster "$CLUSTER_ID"
confluent iam rbac role-binding create \
  --principal Group:TeamBlueRead \
  --role DeveloperRead \
  --resource Subject:prod.teamblue. \
  --prefix \
  --kafka-cluster "$CLUSTER_ID" \
  --schema-registry-cluster "$SCHEMA_REGISTRY_CLUSTER"

confluent iam rbac role-binding create --principal Group:TeamBlueWrite --role DeveloperWrite --resource Topic:prod.teamblue. --prefix --kafka-cluster "$CLUSTER_ID"
confluent iam rbac role-binding create --principal Group:TeamBlueWrite --role DeveloperWrite --resource TransactionalId:prod.teamblue. --prefix --kafka-cluster "$CLUSTER_ID"
confluent iam rbac role-binding create \
  --principal Group:TeamBlueWrite \
  --role DeveloperWrite \
  --resource Subject:prod.teamblue. \
  --prefix \
  --kafka-cluster "$CLUSTER_ID" \
  --schema-registry-cluster "$SCHEMA_REGISTRY_CLUSTER"

confluent iam rbac role-binding create --principal Group:TeamBlueAdmin --role ResourceOwner --resource Topic:prod.teamblue. --prefix --kafka-cluster "$CLUSTER_ID"
confluent iam rbac role-binding create --principal Group:TeamBlueAdmin --role ResourceOwner --resource Group:prod.teamblue. --prefix --kafka-cluster "$CLUSTER_ID"
confluent iam rbac role-binding create --principal Group:TeamBlueAdmin --role ResourceOwner --resource TransactionalId:prod.teamblue. --prefix --kafka-cluster "$CLUSTER_ID"
confluent iam rbac role-binding create \
  --principal Group:TeamBlueAdmin \
  --role ResourceOwner \
  --resource Subject:prod.teamblue. \
  --prefix \
  --kafka-cluster "$CLUSTER_ID" \
  --schema-registry-cluster "$SCHEMA_REGISTRY_CLUSTER"

confluent iam rbac role-binding create \
  --principal Group:TeamBlueAdmin \
  --role ResourceOwner \
  --resource Connector:prod.teamblue. \
  --prefix \
  --kafka-cluster "$CLUSTER_ID" \
  --connect-cluster $CONNECT_CLUSTER_ID

confluent iam rbac role-binding create \
  --principal Group:TeamBlueAdmin \
  --role ResourceOwner \
  --resource KsqlCluster:ksql-cluster \
  --kafka-cluster "$CLUSTER_ID" \
  --ksql-cluster $KSQL_SERVICE_ID

echo "Done!"

#confluent iam rbac role-binding list --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueRead
#confluent iam rbac role-binding list --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueRead --schema-registry-cluster "$SCHEMA_REGISTRY_CLUSTER"
#
#confluent iam rbac role-binding list --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueWrite
#confluent iam rbac role-binding list --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueWrite --schema-registry-cluster "$SCHEMA_REGISTRY_CLUSTER"
#
#confluent iam rbac role-binding list --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueAdmin
#confluent iam rbac role-binding list --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueAdmin --schema-registry-cluster "$SCHEMA_REGISTRY_CLUSTER"
#confluent iam rbac role-binding list --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueAdmin --connect-cluster "$CONNECT_CLUSTER_ID"
#confluent iam rbac role-binding list --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueAdmin --ksql-cluster "$KSQL_SERVICE_ID"

#
#confluent iam rbac role-binding delete --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueRead --role DeveloperRead
#confluent iam rbac role-binding delete --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueRead --schema-registry-cluster "$SCHEMA_REGISTRY_CLUSTER" --role DeveloperRead
#
#confluent iam rbac role-binding delete --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueWrite --role DeveloperWrite
#confluent iam rbac role-binding delete --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueWrite --schema-registry-cluster "$SCHEMA_REGISTRY_CLUSTER" --role DeveloperWrite
#
#confluent iam rbac role-binding delete --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueAdmin --role ResourceOwner
#confluent iam rbac role-binding delete --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueAdmin --schema-registry-cluster "$SCHEMA_REGISTRY_CLUSTER" --role ResourceOwner
#confluent iam rbac role-binding delete --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueAdmin --connect-cluster "$CONNECT_CLUSTER_ID" --role ResourceOwner
#confluent iam rbac role-binding delete --kafka-cluster "$CLUSTER_ID" --principal Group:TeamBlueAdmin --ksql-cluster "$KSQL_SERVICE_ID" --role ResourceOwner
