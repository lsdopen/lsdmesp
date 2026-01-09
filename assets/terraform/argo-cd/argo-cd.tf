
resource "kubernetes_namespace" "lsdmesp-argocd-namespace" {
  metadata {
    name = "lsdmesp-argocd"
  }
}

resource "helm_release" "lsdmesp-argocd" {
  count = var.enabled ? 1 : 0
  name  = "lsdmesp-argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace = kubernetes_namespace.lsdmesp-argocd-namespace.metadata[0].name

  values = [
    file("${path.module}/values-lsdmesp.yaml")
  ]
}
