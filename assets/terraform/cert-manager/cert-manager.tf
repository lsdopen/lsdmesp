resource "helm_release" "cert-manager" {
  count         = var.enabled ? 1 : 0
  name          = "cert-manager"
  chart         = "${path.module}/charts/cert-manager"
  wait          = true
  wait_for_jobs = true
}

resource "helm_release" "cluster-issuer" {
  count         = var.enabled ? 1 : 0
  name          = "cluster-issuer"
  chart         = "${path.module}/charts/cluster-issuer"
  wait          = true
  wait_for_jobs = true

  depends_on = [helm_release.cert-manager]
}
