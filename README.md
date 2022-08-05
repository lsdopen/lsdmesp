# lsdmesp
LSD Event Streaming Platform

### Install
```
helm install lsdmesp-strimzi-operator strimzi/strimzi-kafka-operator -n lsdmesp --create-namespace --values strimzi-kafka-operator.values.yaml
helm upgrade lsdmesp-strimzi-operator strimzi/strimzi-kafka-operator -n lsdmesp --values strimzi-kafka-operator.values.yaml
```

### Restricted Network Installation

Simple installation
```
helm dependency update .
helm install lsdmesp . -n lsdmesp --create-namespace --values values.yaml
```

## Uninstall
```
helm uninstall lsdmesp -n lsdmesp
helm uninstall lsdmesp-strimzi-operator --namespace lsdmesp 
kubectl delete crd -l app=strimzi
kubectl delete ns lsdmesp
```
