## Installation

`./install.sh`

Once pod is running:
`kubectl exec -it vault-0 -n hashicorp -- /bin/sh`

Inside pod, execute the following:
```
vault auth enable kubernetes

echo $KUBERNETES_PORT_443_TCP_ADDR
vault write auth/kubernetes/config \
  token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

Create a Vault policy file for all secrets stored in path `/secrets/lsdmesp-confluent/` and copy it to the vault pod
``` 
cat ./app-policy.hcl
kubectl -n hashicorp cp ./app-policy.hcl vault-0:/tmp
```

Exec back into the pod:
`kubectl exec -it vault-0 -n hashicorp -- /bin/sh`

Inside pod, execute the following:
```
vault write sys/policy/app policy=@/tmp/app-policy.hcl
vault write auth/kubernetes/role/confluent-operator \
  bound_service_account_names=default \
  bound_service_account_namespaces=lsdmesp-confluent \
  policies=app \
  ttl=24h
```

Copy all plaintext secrets to Vault pod
`kubectl -n hashicorp cp ./credentials vault-0:/tmp`

Add all secrets to Vault
```
kubectl exec -it vault-0 -n hashicorp -- /bin/sh -c "cat /tmp/credentials/connect/bearer.txt | base64 | vault kv put /secret/lsdmesp-confluent/connect-bearer.txt bearer=-"
kubectl exec -it vault-0 -n hashicorp -- /bin/sh -c "cat /tmp/credentials/controlcenter/bearer.txt | base64 | vault kv put /secret/lsdmesp-confluent/controlcenter-bearer.txt bearer=-"
kubectl exec -it vault-0 -n hashicorp -- /bin/sh -c "cat /tmp/credentials/kafka/bearer.txt | base64 | vault kv put /secret/lsdmesp-confluent/kafka/bearer.txt bearer=-"
kubectl exec -it vault-0 -n hashicorp -- /bin/sh -c "cat /tmp/credentials/kafkarestclass/bearer.txt | base64 | vault kv put /secret/lsdmesp-confluent/kafkarestclass/bearer.txt bearer=-"
kubectl exec -it vault-0 -n hashicorp -- /bin/sh -c "cat /tmp/credentials/kafkarestproxy/bearer.txt | base64 | vault kv put /secret/lsdmesp-confluent/kafkarestproxy/bearer.txt bearer=-"
kubectl exec -it vault-0 -n hashicorp -- /bin/sh -c "cat /tmp/credentials/ksqldb/bearer.txt | base64 | vault kv put /secret/lsdmesp-confluent/ksqldb/bearer.txt bearer=-"
kubectl exec -it vault-0 -n hashicorp -- /bin/sh -c "cat /tmp/credentials/schemaregistry/bearer.txt | base64 | vault kv put /secret/lsdmesp-confluent/schemaregistry/bearer.txt bearer=-"

kubectl exec -it vault-0 -n hashicorp -- /bin/sh -c "cat /tmp/credentials/mds/ldap.txt | base64 | vault kv put /secret/lsdmesp-confluent/mds/ldap.txt ldapsimple=-"
kubectl exec -it vault-0 -n hashicorp -- /bin/sh -c "cat /tmp/credentials/mds/mdsPublicKey.txt | base64 | vault kv put /secret/lsdmesp-confluent/mds/mdsPublicKey.pem mdspublickey=-"
kubectl exec -it vault-0 -n hashicorp -- /bin/sh -c "cat /tmp/credentials/mds/mdsTokenKeyPair.txt | base64 | vault kv put /secret/lsdmesp-confluent/mds/mdsTokenKeyPair.pem mdstokenkeypair=-"
```
