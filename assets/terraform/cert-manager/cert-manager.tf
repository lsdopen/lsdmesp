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

resource "null_resource" "wait_for_instance" {
  provisioner "local-exec" {
    command = <<EOT
    for i in $(seq 1 20); do
      READY=`kubectl get pods -n cert-manager | grep cert-manager-webhook | awk '{print $2}'`
      if [ X"$READY" = X"1/1" ]; then
        echo "Cert manager webhook is running! READY: $READY"
        sleep 5
        break
      else
        echo "Waiting for cert manager webhook to start. READY: $READY"
        sleep 5
      fi
    done
    EOT
  }
}
