
resource "helm_release" "lsdmesp-seaweedfs" {
  count = var.enabled ? 1 : 0
  name  = "lsdmesp-seaweedfs"

  repository = "https://seaweedfs.github.io/seaweedfs/helm"
  chart      = "seaweedfs"

  namespace = "lsdmesp"

  values = [
    file("${path.module}/seaweedfs-values.yaml")
  ]
}
