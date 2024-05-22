#!/bin/bash

helm dependency update .
kubectl create ns lsdmesp-confluent
kubectl config set-context --current --namespace lsdmesp-confluent
helm install lsdmesp-confluent . -f ../../values.yaml -n lsdmesp-confluent
