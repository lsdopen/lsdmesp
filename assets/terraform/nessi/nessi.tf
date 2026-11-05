resource "helm_release" "nessi" {
  count         = var.enabled ? 1 : 0
  name          = "nessi"
  chart         = "${path.module}/charts/nessi"
  namespace     = "lsdmesp"
  wait          = true
  wait_for_jobs = true
}
