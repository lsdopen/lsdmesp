#! /bin/bash

kubectl create ns hashicorp
helm repo add hashicorp https://helm.releases.hashicorp.com
helm upgrade --install vault --set='server.dev.enabled=true' hashicorp/vault -n hashicorp
