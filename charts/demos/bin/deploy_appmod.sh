#!/bin/bash

# Create App Modernisation namespace
kubectl create namespace app-modernisation

# Add Confluent CA certificate secret to app-modernisation namespace
CONFLUENT_TLS_CRT=$(kubectl -n lsdmesp-confluent get secret ca-pair-sslcerts -ojsonpath="{.data['tls\.crt']}")
kubectl create secret generic confluent-ca --namespace app-modernisation --from-literal=ca.crt=placeholder
kubectl patch secret confluent-ca --namespace app-modernisation -p "{\"data\":{\"ca.crt\":\"${CONFLUENT_TLS_CRT}\"}}"

# Create secret for microservice
kubectl create secret generic kafka-secrets --namespace app-modernisation \
--from-literal=BOOTSTRAP_SERVERS="kafka.lsdmesp-confluent.svc.cluster.local:9092" \
--from-literal=CLIENT_KEY="peter" \
--from-literal=CLIENT_SECRET="peter-secret" \
--from-literal=SASL_JAAS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username='peter' password='peter-secret'" \
--from-literal=SCHEMA_REGISTRY_API_KEY="peter" \
--from-literal=SCHEMA_REGISTRY_API_SECRET="peter-secret" \
--from-literal=SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO="peter:peter-secret" \
--from-literal=SCHEMA_REGISTRY_URL="https://schemaregistry.lsdmesp-confluent.svc.cluster.local:8081" \
--from-literal=KSQLDB_API_KEY="peter" \
--from-literal=KSQLDB_API_SECRET="peter-secret" \
--from-literal=KSQLDB_APP_ENDPOINT="https://ksqldb.lsdmesp-confluent.svc.cluster.local:8088"

# Deploy Monolith app, Webapp and Ingress for Webapp
kubectl apply -f ../templates/020-monolith-deployment.yaml -n app-modernisation
kubectl apply -f ../templates/021-monolith-service.yaml -n app-modernisation
kubectl apply -f ../templates/030-webapp-deployment-mf1.yaml -n app-modernisation
kubectl apply -f ../templates/031-webapp-service.yaml -n app-modernisation
kubectl apply -f ../templates/032-webapp-ingress.yaml -n app-modernisation

# Create scaled down Microservice app and service, Webapp 2 and Webapp 3
kubectl apply -f ../templates/040-microservice-deployment.yaml -n app-modernisation
kubectl apply -f ../templates/041-microservice-service.yaml -n app-modernisation
kubectl apply -f ../templates/050-webapp-deployment-mf2.yaml -n app-modernisation
kubectl apply -f ../templates/060-webapp-deployment-mf3.yaml -n app-modernisation
