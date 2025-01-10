provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  debug = true
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "eks-blueprint-mesp" {
  source  = "app.terraform.io/lsdopen/eks-blueprint-mesp/aws"
  version = "1.3.1"

  cluster_name             = "kind"
  base_url                 = "apps.mesp.lsdopen.io"
  cluster_issuer_name      = "issuer"
  ingress_class_name       = "nginx"
  kafka_ingress_class_name = "nginx"

  namespace = "lsdmesp"

  strimzi               = true
  monitoring            = false
  army_knife = {
    enabled  = false
    replicas = 1
  }
  strimzi_storage_class = "standard"
}
