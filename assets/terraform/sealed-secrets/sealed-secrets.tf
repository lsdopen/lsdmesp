
resource "helm_release" "lsdmesp-sealed-secrets" {
  count = var.enabled ? 1 : 0
  name  = "lsdmesp-sealed-secrets"

  repository = "https://bitnami.github.io/sealed-secrets"
  chart      = "sealed-secrets"

  namespace = "kube-system"

  values = [
    file("${path.module}/values-lsdmesp.yaml")
  ]
}
