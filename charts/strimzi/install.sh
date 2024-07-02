#!/bin/bash

openssl genrsa -out ca-key.pem 2048
openssl req -new -key ca-key.pem -x509 -days 3650 -out ca.pem -subj "/C=ZA/ST=GP/L=Johannesburg/O=io.strimzi/OU=Operator/CN=LocalCA" -config sans.conf -extensions 'v3_req'
openssl x509 -in ca.pem -noout -text

kubectl label node kind-worker accept-pod=lsdmesp-broker-0
kubectl label node kind-worker2 accept-pod=lsdmesp-broker-1
kubectl label node kind-worker3 accept-pod=lsdmesp-broker-2

helm dependency update .
kubectl create ns lsdmesp
kubectl config set-context --current --namespace lsdmesp
kubectl create secret tls lsdmesp-external-ca-cert --cert=ca.pem --key=ca-key.pem
helm install lsdmesp . -f values.yaml -n lsdmesp
