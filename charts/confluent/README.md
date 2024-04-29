# lsdmesp-confluent

LSD Managed Event Streaming Platform (MESP) Charts for Confluent (CfK)

## Helm setup

Prepare for offline install

```
helm dependency update .
```

## Deploy LSDMESP with Confluent for Kubernetes

Create the namespaces
```
kubectl create ns lsdmesp-confluent
kubectl config set-context --current --namespace lsdmesp-confluent
```

Set PROJECT_HOME env var to project directory
```
PROJECT_HOME=$PWD
```

### Create secrets with random passwords and certs

TODO

### Deploy:

`(Optional)` Deploy OpenLDAP for RBAC (if no external LDAP server is available):
```
LDAP_CHART_HOME=$PROJECT_HOME/assets/openldap
helm upgrade --install ldap-dev $LDAP_CHART_HOME --namespace lsdmesp-confluent
```

Test OpenLDAP:
```
kubectl --namespace lsdmesp-confluent exec -it ldap-0 -- bash
ldapsearch -LLL -x -H ldap://ldap.lsdmesp-confluent.svc.cluster.local:389 -b 'dc=test,dc=com' -D "cn=mds,dc=test,dc=com" -w 'Developer!'
```

### Deploy LSDMESP:
```
helm install lsdmesp-confluent . -f values.yaml -n lsdmesp-confluent
```

## Uninstall LSDMESP


Before you start uninstall the chart, run these command:

```shell
kubectl delete kafkas.platform.confluent.io --all
kubectl delete controlcenters.platform.confluent.io --all
kubectl delete connect.platform.confluent.io --all
kubectl delete schemaregistries.platform.confluent.io --all
kubectl delete kafkarestproxies.platform.confluent.io --all
kubectl delete kraftcontrollers.platform.confluent.io --all
kubectl delete ksqldbs.platform.confluent.io --all
kubectl delete kafkarestclasses.platform.confluent.io --all
```

Uninstall the chart

```shell
helm uninstall lsdmesp-confluent -n lsdmesp-confluent
for crd in $(kubectl get crd --no-headers -ojsonpath='{.items[*].metadata.name}' | grep confluent); do kubectl delete crd $crd; done
kubectl delete ns lsdmesp-confluent
```
