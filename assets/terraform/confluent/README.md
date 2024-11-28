# Kind deployment via Terraform

## Create Kind cluster

`kind create cluster --config ~/.kindconf/lsdmesp.conf`

## Create Ingress controller

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml`

## Terraform apply

```
export TF_TOKEN_app_terraform_io=<token>
terraform apply
```
