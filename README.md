# lsdmesp-confluent
LSD Managed Event Streaming Platform (MESP) Charts for Confluent (CfK)

Create the namespaces
```
kubectl create ns lsdmesp-confluent
```

Create certs

```
openssl genrsa -out $TUTORIAL_HOME/ca-key.pem 2048
```

```
openssl req -new -key $TUTORIAL_HOME/ca-key.pem -x509 \
  -days 1000 \
  -out $TUTORIAL_HOME/ca.pem \
  -subj "/C=US/ST=CA/L=MountainView/O=Confluent/OU=Operator/CN=LocalCA"
```

```
kubectl create secret tls ca-pair-sslcerts \
  --cert=$TUTORIAL_HOME/ca.pem \
  --key=$TUTORIAL_HOME/ca-key.pem -n confluent-lsdmesp
```

Deploy:
```
helm install lsdmesp-confluent . -f values.yaml -n lsdmesp-confluent
```
