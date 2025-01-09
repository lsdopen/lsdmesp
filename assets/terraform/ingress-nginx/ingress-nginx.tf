provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  debug = true
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "ingress-nginx" {
  count         = var.enabled ? 1 : 0
  name          = "ingress-nginx"
  chart         = "${path.module}/charts/kind"
  wait          = true
  wait_for_jobs = true
}

resource "null_resource" "wait_for_instance" {
  provisioner "local-exec" {
    command = <<EOT
    for i in $(seq 1 20); do
      READY=`kubectl get pods -n ingress-nginx | grep controller | awk '{print $2}'`
      if [ X"$READY" = X"1/1" ]; then
        echo "Nginx is running! READY: $READY"
        sleep 5
        break
      else
        echo "Waiting for nginx to start. READY: $READY"
        sleep 5
      fi
    done
    EOT
  }
}
