#!/bin/bash

kubectl create -f https://github.com/jetstack/cert-manager/releases/download/v1.16.2/cert-manager.yaml
echo "Sleeping a bit for cert-manager"
sleep 10
echo "Done!"
helm dependency update .
kubectl create ns lsdmesp
kubectl config set-context --current --namespace lsdmesp
helm install lsdmesp . -f ../../values.yaml -n lsdmesp
