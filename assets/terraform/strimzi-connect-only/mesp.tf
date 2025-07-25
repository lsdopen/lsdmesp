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
  source = "app.terraform.io/lsdopen/eks-blueprint-mesp/aws"
  version = "1.5.28"

  # cluster_name             = "kind"
  base_url                 = "mesp.lsdopen.io"
  cluster_issuer_name      = "issuer"
  ingress_class_name       = "nginx"
  kafka_ingress_class_name = "nginx"

  namespace = "lsdmesp"

  strimzi_connect_only                  = true
  strimzi_connect_only_bootstrap_server = var.strimzi_connect_only_bootstrap_server
  strimzi_connect_only_aws_arn          = var.strimzi_connect_only_aws_arn
}
