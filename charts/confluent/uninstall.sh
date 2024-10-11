#!/bin/bash

function patchFinalizers() {
  kubectl patch controlcenter controlcenter -p '{"metadata":{"finalizers":null}}' --type=merge
  kubectl patch kafkarestproxy kafkarestproxy -p '{"metadata":{"finalizers":null}}' --type=merge
  kubectl patch ksqldb ksqldb -p '{"metadata":{"finalizers":null}}' --type=merge
  kubectl patch connect connect -p '{"metadata":{"finalizers":null}}' --type=merge
  kubectl patch schemaregistry schemaregistry -p '{"metadata":{"finalizers":null}}' --type=merge
  kubectl patch kafkarestclasses.platform.confluent.io default -p '{"metadata":{"finalizers":null}}' --type=merge
  kubectl patch kafka.platform.confluent.io/kafka -p '{"metadata":{"finalizers":null}}' --type=merge
  kubectl patch kraftcontroller kraftcontroller -p '{"metadata":{"finalizers":null}}' --type=merge
  kubectl get secret | awk '{print $1}' | grep -v NAME | xargs -I {} kubectl patch secret {} -p '{"metadata":{"finalizers":null}}' --type=merge
  kubectl get cfrb | awk '{print $1}' | grep -v NAME | xargs -I {} kubectl patch cfrb {} -p '{"metadata":{"finalizers":null}}' --type=merge
}

patchFinalizers
helm uninstall lsdmesp
sleep 5
patchFinalizers

kubectl get pvc | awk '{print $1}' | grep -v NAME | xargs -I {} kubectl delete pvc {}
kubectl get pv | awk '{print $1}' | grep -v NAME | xargs -I {} kubectl delete pv {}

# aws ec2 describe-volumes --filter "Name=tag:Name,Values=EBS-CSI-lsdmesp-*" --query "Volumes[*].{ID:VolumeId,VolName:Tags[?Key=='Name']|[0].Value}" | jq -r ".[].ID" | xargs -I {} aws ec2 delete-volume --volume-id {}
