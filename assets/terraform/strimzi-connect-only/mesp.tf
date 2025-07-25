provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  debug = true
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

module "eks-blueprint-mesp" {
  source  = "app.terraform.io/lsdopen/eks-blueprint-mesp/aws"
  version = "1.5.30"

  base_url                 = "mesp.lsdopen.io"
  cluster_issuer_name      = "issuer"
  ingress_class_name       = "nginx"
  kafka_ingress_class_name = "nginx"

  namespace = "lsdmesp"

  strimzi_connect_only                  = true
  strimzi_connect_only_bootstrap_server = var.strimzi_connect_only_bootstrap_server
  strimzi_connect_only_connect_password = random_password.connect_only_password.result
  strimzi_connect_only_aws_arn          = var.strimzi_connect_only_aws_arn
}

resource "random_password" "connect_only_password" {
  length      = 16
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  min_special = 1
}
