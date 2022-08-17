#Deploy

```
kubectl create ns lsdmesp
```

Copy helm  deploy files

```
helm install -f values.yaml lsdmesp . -n lsdmesp
```

Post-deployment


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
kubectl get pods -n lsdmesp | grep cp-ksql-server | head -n 1 | awk '{print $1}' | xargs -I{} kubectl cp ./extra.files/ksql.udf/clicks-udf-1.0.3.jar {}:/opt/ksqldb-udfs/clicks-udf-1.0.3.jar -c cp-ksql-server -n lsdmesp
```
You might see the following msg. This can be ignored as the jar has actually copied correctly.
```
tar: clicks-udf-1.0.3.jar: Cannot change ownership to uid 1001, gid 1001: Operation not permitted
tar: Exiting with failure status due to previous errors
command terminated with exit code 2
```

