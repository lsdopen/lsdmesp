# Argo CD

One can login to the ui using these steps:

Username: admin
Password is auto generated and can be found like this:

```
kubectl -n lsdmesp-argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Forward port:

```
kubectl port-forward service/lsdmesp-argocd-server -n lsdmesp-argocd 8080:443
```
