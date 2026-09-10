# Sealed Secrets

One can export an existing sealed secrets key from a cluster using the following command:

```
kubectl -n kube-system get secret sealed-secrets-keylgxdl  -o yaml > sealed-secret.keys
```

And one can apply it to a new cluster using the following command:

```
kc apply -f ./sealed-secret.keys
```

This is usually required to make sure that the same sealed secret works across different clusters.
