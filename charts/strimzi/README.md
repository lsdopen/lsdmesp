# Deploy

Label the nodes for node affinity. This will force the Kafka brokers to be scheduled on to specific nodes.
FNB Production example below:
```
kubectl label node cts-rbkfkpopp01 accept-pod=lsdmesp-kafka-0
kubectl label node cts-rbkfkpopp02 accept-pod=lsdmesp-kafka-1
kubectl label node cts-rbkfkpopp03 accept-pod=lsdmesp-kafka-2
```

Create the namespaces
```
kubectl create ns lsdmesp
```

Create a secret for the ca cert to be used by the Kafka nodeports
```
kubectl get secret ingress-default-cert --namespace=ingress-nginx -o yaml | sed 's/name: .*/name: lsdmesp-external-ca-cert/' | sed 's/namespace: .*/namespace: lsdmesp/' | kubectl apply -f -
```

Deploy:
```
helm install lsdmesp . -f values.yaml -n lsdmesp; helm upgrade lsdmesp . -f values.yaml -n lsdmesp
```

If using KSQL, patch KSQL deployment to include UDFs NFS share. This allows for adding custom UDFs to be used in KSQL.
FNB is NOT currently using KSQL
```
cat <<EOF | kubectl patch deployment lsdmesp-cp-ksql-server --patch "
spec:
  template:
    spec:
      containers:
      - name: cp-ksql-server
        volumeMounts:
        - mountPath: /opt/ksqldb-udfs
          name: udfs
      volumes:
      - name: udfs
        persistentVolumeClaim:
          claimName: udfs-lsdmesp-cp-ksql-server
"
EOF
```

Any UDFs should be added to a directory called ./extra.files/ksql.udf/
Copy UDFs to NFS share
```
kubectl get pods -n lsdmesp | grep cp-ksql-server | head -n 1 | awk '{print $1}' | xargs -I{} kubectl cp ./extra.files/ksql.udf/*.jar {}:/opt/ksqldb-udfs/ -c cp-ksql-server -n lsdmesp
```
You might see the following when trying to copy the jar.   Just ignore this as the jar would have copied.
```
tar: clicks-udf-1.0.4.jar: Cannot change ownership to uid 1001, gid 1001: Operation not permitted
tar: Exiting with failure status due to previous errors
command terminated with exit code 2
```

See /doc/tests.md for post-installation checks and testing.

----


# Rolling certificates

All Strimzi certificates are automatically updated 30 days before expiry. CA and client certificates can, however, be manually rolled by annotating the relevant secrets:
- `lsdmesp-cluster-ca-cert`
- `lsdmesp-clients-ca-cert`

The validity period for the certificates can be modified in the Kafka custom resource on the top level under `spec`. Current settings as follows:

```yaml
spec:
  clientsCa:
    generateCertificateAuthority: true
    renewalDays: 30
    validityDays: 3650
  clusterCa:
    generateCertificateAuthority: true
    renewalDays: 30
    validityDays: 3650
```

The expiry dates of the CA and client certs can be verified by running the following `kubectl` commands:
```
kubectl get secret lsdmesp-cluster-ca-cert -o 'jsonpath={.data.ca\.crt}' | base64 -d | openssl x509 -subject -issuer -startdate -enddate -noout
kubectl get secret lsdmesp-clients-ca-cert -o 'jsonpath={.data.ca\.crt}' | base64 -d | openssl x509 -subject -issuer -startdate -enddate -noout
```

To roll the certificates manually, the secrets can be annotated as follows:
```
kubectl annotate secret lsdmesp-cluster-ca-cert strimzi.io/force-renew=true
kubectl annotate secret lsdmesp-clients-ca-cert strimzi.io/force-renew=true
```

Once the certificates have been rolled, all secrets for all users will be update with these new certificates. Client application will then need to be updated with the new certificates.

The `get_user_certs.sh` and `create_client_properties.sh` shell scripts can be used to extract the certificates and generate a new `.properties` file per user.

Example for `pop-dev-user`:
```
cd ./scripts/bin
./get_user_certs pop-dev-user
./create_client_properties.sh pop-dev-user
```
