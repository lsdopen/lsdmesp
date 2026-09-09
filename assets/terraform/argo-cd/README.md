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

## Ahoy

For Ahoy add this:

> kc edit cm argocd-cm -n lsdmesp-argocd

```
accounts.ahoy: login,apiKey
accounts.ci-automation: apiKey
```

> kc edit cm argocd-rbac-cm -n lsdmesp-argocd

```
policy.csv: g, ahoy, role:admin
```
