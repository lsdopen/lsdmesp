# lsdmesp-confluent
LSD Managed Event Streaming Platform (MESP) Charts for Confluent (CfK)

Create the namespaces
```
kubectl create ns lsdmesp-confluent
```

Set PROJECT_HOME env var to project directory
```
PROJECT_HOME=$PWD
```

Create certs
```
openssl genrsa -out $PROJECT_HOME/certs/ca-key.pem 2048
```

```
openssl req -new -key $PROJECT_HOME/certs/ca-key.pem -x509 \
  -days 3650 \
  -out $PROJECT_HOME/certs/ca.pem \
  -subj "/C=US/ST=CA/L=MountainView/O=Confluent/OU=Operator/CN=LocalCA"
```

```
kubectl create secret tls ca-pair-sslcerts \
  --cert=$PROJECT_HOME/certs/ca.pem \
  --key=$PROJECT_HOME/certs/ca-key.pem -n lsdmesp-confluent
```

Deploy:
```
helm install lsdmesp-confluent . -f values.yaml -n lsdmesp-confluent
```


```
[2024-01-10 15:34:38,866] INFO [control-center-heartbeat-1] misconfigured topic=_confluent-metrics config=min.insync.replicas value=1 expected=2 (io.confluent.controlcenter.healthcheck.AllHealthCheck)
[2024-01-10 15:34:38,866] INFO [control-center-heartbeat-1] misconfigured topic=_confluent-metrics config=retention.ms value=259200000 expected=21600000 (io.confluent.controlcenter.healthcheck.AllHealthCheck)
```