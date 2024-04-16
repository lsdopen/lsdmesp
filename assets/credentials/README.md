
## Create the secret files and cert files

### For the mds pem key pair:

- https://docs.confluent.io/platform/current/kafka/configure-mds/index.html

```
openssl genrsa -out ./credentials/mds-tokenkeypair.pem 2048

openssl rsa -in ./credentials/mds-tokenkeypair.pem -outform PEM -pubout -out ./credentials/mds-publickey.pem
```

### For the ca-key.pem and ca.pem files:

```
openssl genrsa -out ./credentials/ca-key.pem 2048

openssl req -new -key ./credentials/ca-key.pem -x509 \
-days 3650 \
-out ./credentials/ca.pem \
-subj "/C=US/ST=CA/L=MountainView/O=Confluent/OU=Operator/CN=LocalCA"
```

### For others

For all these:

connect.txt
controlcenter.txt
kafka.txt
kafkarestclass.txt
kafkarestproxy.txt
ksqldb.txt
ldap-user.txt
schemaregistry.txt

Generate a fresh password and replace the password in the file and in the ldap values.yaml

## Create the secrets from the generated password and cert files

```
kubectl create secret tls ca-pair-sslcerts \
  --cert=./credentials/ca.pem \   
  --key=./credentials/ca-key.pem \
  --dry-run=client -oyaml >./templates/000.ca-pair-sslcerts.yaml
```

```
kubectl create secret generic mds-token \
  --from-file=mdsPublicKey.pem=./credentials/mds-publickey.pem \
  --from-file=mdsTokenKeyPair.pem=./credentials/mds-tokenkeypair.pem \
  --dry-run=client -oyaml >./templates/000.mds-token.yaml
```

```
kubectl create secret generic mds-login \
  --from-file=ldap.txt=./credentials/ldap-user.txt \
  --dry-run=client -oyaml >./templates/000.mds-login.yaml
```

```
kubectl create secret generic connect-login \
  --from-file=bearer.txt=./credentials/connect.txt \
  --from-file=basic.txt=./credentials/connect.txt \
  --dry-run=client -oyaml >./templates/000.connect-login.yaml
```

```
kubectl create secret generic controlcenter-login \
  --from-file=bearer.txt=./credentials/controlcenter.txt \
  --dry-run=client -oyaml >./templates/000.controlcenter-login.yaml
```

```
kubectl create secret generic kafka-login \
  --from-file=bearer.txt=./credentials/kafka.txt \
  --dry-run=client -oyaml >./templates/000.kafka-login.yaml
```

```
kubectl create secret generic kafkarestclass-login \
  --from-file=basic.txt=./credentials/kafkarestclass.txt \
  --from-file=bearer.txt=./credentials/kafkarestclass.txt \
  --dry-run=client -oyaml >./templates/000.kafkarestclass-login.yaml
```

```
kubectl create secret generic kafkarestproxy-login \
  --from-file=bearer.txt=./credentials/kafkarestproxy.txt \
  --dry-run=client -oyaml >./templates/000.kafkarestproxy-login.yaml
```

```
kubectl create secret generic ksqldb-login \
  --from-file=bearer.txt=./credentials/ksqldb.txt \
  --from-file=basic.txt=./credentials/ksqldb.txt \
  --dry-run=client -oyaml >./templates/000.ksqldb-login.yaml
```

```
kubectl create secret generic schemaregistry-login \
  --from-file=bearer.txt=./credentials/schemaregistry.txt \
  --from-file=basic.txt=./credentials/schemaregistry.txt \
  --dry-run=client -oyaml >./templates/000.schemaregistry-login.yaml
```
