
resource "kubernetes_namespace" "lsdmesp-sealed-secrets-namespace" {
  metadata {
    name = "kube-system"
  }
}

resource "helm_release" "lsdmesp-sealed-secrets" {
  count = var.enabled ? 1 : 0
  name  = "lsdmesp-sealed-secrets"

  repository = "https://bitnami.github.io/sealed-secrets"
  chart      = "sealed-secrets"

  namespace = kubernetes_namespace.lsdmesp-sealed-secrets-namespace.metadata[0].name

  values = [
    file("${path.module}/values-lsdmesp.yaml")
  ]
}
