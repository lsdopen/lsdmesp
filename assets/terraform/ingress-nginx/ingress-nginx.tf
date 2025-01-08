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
    for i in $(seq 1 30); do
      CHECK=`kubectl get pods -n ingress-nginx | grep controller | awk '{print $2}'`
      echo "CHECK: $CHECK"
      if [ X"$CHECK" = X"1/1" ]; then
        echo "Nginx is running!"
        break
      else
        echo "Waiting for nginx to start..."
        sleep 2
      fi
    done
    EOT
  }
}
