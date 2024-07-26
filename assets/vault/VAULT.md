
# Export secrets

kc get secret ca-pair-sslcerts -ojson | jq -r '.data."tls.crt"' | base64 -d > tls-crt.txt
kc get secret ca-pair-sslcerts -ojson | jq -r '.data."tls.key"' | base64 -d > tls-key.txt
kc get secret connect-login -ojson | jq -r '.data."basic.txt"' | base64 -d > connect-login.txt
kc get secret controlcenter-login -ojson | jq -r '.data."bearer.txt"' | base64 -d > controlcenter-login.txt
kc get secret kafka-login -ojson | jq -r '.data."bearer.txt"' | base64 -d > kafka-login.txt
kc get secret kafkarestproxy-login -ojson | jq -r '.data."bearer.txt"' | base64 -d > kafkarestproxy-login.txt
kc get secret ksqldb-login -ojson | jq -r '.data."bearer.txt"' | base64 -d > ksqldb-login.txt
kc get secret mds-login -ojson | jq -r '.data."ldap.txt"' | base64 -d > mds-login.txt
kc get secret mds-token -ojson | jq -r '.data."mdsPublicKey.pem"' | base64 -d > mds-token-public-key.txt
kc get secret mds-token -ojson | jq -r '.data."mdsTokenKeyPair.pem"' | base64 -d > mds-token-private-key.txt
kc get secret schemaregistry-login -ojson | jq -r '.data."basic.txt"' | base64 -d > schemaregistry-login.txt

# Import secrets into vault

vault kv put kvv2/confluent/ca-pair-sslcerts tls.crt=@tls-crt.txt tls.key=@tls-key.txt
vault kv put kvv2/confluent/connect-login basic.txt=@connect-login.txt bearer.txt=@connect-login.txt
vault kv put kvv2/confluent/controlcenter-login bearer.txt=@controlcenter-login.txt
vault kv put kvv2/confluent/kafka-login bearer.txt=@kafka-login.txt
vault kv put kvv2/confluent/kafkarestclass-login basic.txt=@kafka-login.txt bearer.txt=@kafka-login.txt
vault kv put kvv2/confluent/kafkarestproxy-login bearer.txt=@kafkarestproxy-login.txt
vault kv put kvv2/confluent/ksqldb-login basic.txt=@ksqldb-login.txt bearer.txt=@ksqldb-login.txt
vault kv put kvv2/confluent/mds-login ldap.txt=@mds-login.txt
vault kv put kvv2/confluent/mds-token mdsPublicKey.pem=@mds-token-public-key.txt mdsTokenKeyPair.pem=@mds-token-private-key.txt
vault kv put kvv2/confluent/schemaregistry-login basic.txt=@schemaregistry-login.txt bearer.txt=@schemaregistry-login.txt

# Appendix

## Vault Dev Install

## Helm install vault

```
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm install vault hashicorp/vault -n vault --create-namespace --values vault-values.yaml
```

## Configure vault

```
kubectl exec --stdin=true --tty=true vault-0 -n vault -- /bin/sh

cd tmp

vault auth enable -path demo-auth-mount kubernetes

vault write auth/demo-auth-mount/config \
   kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"

vault secrets enable -path=kvv2 kv-v2

tee dev.json <<EOF
path "kvv2*" {
   capabilities = ["read", "list"]
}
EOF

vault policy write dev dev.json

vault write auth/demo-auth-mount/role/role1 \
   bound_service_account_names=default \
   bound_service_account_namespaces=lsdmesp-confluent  \
   policies=dev \
   audience=vault \
   ttl=24h

exit
```

### Helm install vault secrets operator

```
helm install vault-secrets-operator hashicorp/vault-secrets-operator -n vault-secrets-operator-system --create-namespace --values vault-operator-values.yaml
```

