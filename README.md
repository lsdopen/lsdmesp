#Deploy

Label the nodes for node affinity. Prod example below:
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


Patch KSQL deployment to include UDFs NFS share
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

Copy UDFs to NFS share
```
kubectl get pods -n lsdmesp | grep cp-ksql-server | head -n 1 | awk '{print $1}' | xargs -I{} kubectl cp ./extra.files/ksql.udf/clicks-udf-1.0.4.jar {}:/opt/ksqldb-udfs/clicks-udf-1.0.4.jar -c cp-ksql-server -n lsdmesp
```
You might see the following when trying to copy the jar.   Just ignore this as the jar would have copied.
```
tar: clicks-udf-1.0.4.jar: Cannot change ownership to uid 1001, gid 1001: Operation not permitted
tar: Exiting with failure status due to previous errors
command terminated with exit code 2
```
