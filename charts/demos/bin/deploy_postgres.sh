#!/bin/bash

kubectl create ns postgres
kubectl apply -f ../templates/005-postgres.yaml -n postgres
