#Deploy

Create the namespaces
```
kubectl create ns kafka-system lsdmesp
```

Copy helm  deploy files

Start with the Strimzi Operator
```
cd strimzi
helm install -f values.yaml lsdmesp-strimzi . -n kafka-system
```

Now deploy the rest:
```
cd ../lsdmesp
helm install -f values.yaml lsdmesp . -n lsdmesp
```

Wait for all pods to deploy.
KafkaConnect is scaled down to 0 replicas.


#Post-deployment
Scale up the Connect pods

```
k edit KafkaConnect
```
Find the replicas and update to 3
:wq


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
You might see the following when trying to copy the jar.   Just ignore this as the jar would have copied.
```
tar: clicks-udf-1.0.3.jar: Cannot change ownership to uid 1001, gid 1001: Operation not permitted
tar: Exiting with failure status due to previous errors
command terminated with exit code 2
```

Update the Kafka Manager UI:
Find url in ingress.
Click on Cluster ->  Add Cluster.
Give cluster name "lsdmesp"
Set Cluster Zookeeper hosts: "zoo-entrance:2181"
Select the following settings (tick box)
- Enable JMX Polling (Set JMX_PORT env variable before starting kafka server)
- Poll consumer information (Not recommended for large # of consumers)
- Filter out inactive consumers
- Enable Logkafka
- Enable Active OffsetCache (Not recommended for large # of consumers)



