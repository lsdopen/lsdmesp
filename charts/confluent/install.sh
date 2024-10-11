#!/bin/bash

helm dependency update .
kubectl create ns lsdmesp
kubectl config set-context --current --namespace lsdmesp
helm install lsdmesp . -f ../../values.yaml -n lsdmesp
