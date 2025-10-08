# Deploy

Label the nodes for node affinity. This will force the Kafka brokers to be scheduled on to specific nodes.
Example below:
```
kubectl label node prdworker01 accept-pod=lsdmesp-broker-0
kubectl label node prdworker02 accept-pod=lsdmesp-broker-1
kubectl label node prdworker03 accept-pod=lsdmesp-broker-2
```

Create the namespaces
```
kubectl create ns lsdmesp
```

Create a secret for the ca cert to be used by the Kafka nodeports
```
kubectl get secret ingress-default-cert --namespace=ingress-nginx -o yaml | sed 's/name: .*/name: lsdmesp-tls/' | sed 's/namespace: .*/namespace: lsdmesp/' | kubectl apply -f -
```

Deploy:
```
helm install lsdmesp . -f values.yaml -n lsdmesp; helm upgrade lsdmesp . -f values.yaml -n lsdmesp
```

If using KSQL, patch KSQL deployment to include UDFs NFS share. This allows for adding custom UDFs to be used in KSQL.
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
tar: lsdmesp-udf-1.0.4.jar: Cannot change ownership to uid 1001, gid 1001: Operation not permitted
tar: Exiting with failure status due to previous errors
command terminated with exit code 2
```

## Post installation checks:

See ./post-deploy/doc/tests.md for post-installation checks and testing.
Please see ./tests


# Deploying on Kind

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml

you may need a nodeSelector to start Ingress up on the control plane node

with kind.conf of:
```
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
```