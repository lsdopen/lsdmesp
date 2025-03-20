provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  debug = true
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "ingress-nginx" {
  source  = "../ingress-nginx"
  enabled = var.enable-ingress-nginx

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}

module "cert-manager" {
  source  = "../cert-manager"
  enabled = var.enable-cert-manager

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  depends_on = [module.ingress-nginx]
}

module "observe" {
  source  = "../observe"
  enabled = var.enable-monitoring

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  depends_on = [module.ingress-nginx]
}

module "eks-blueprint-mesp" {
  source  = "app.terraform.io/lsdopen/eks-blueprint-mesp/aws"
  version = "1.5.12"

  cluster_name             = "kind"
  base_url                 = "apps.mesp.lsdopen.io"
  cluster_issuer_name      = "issuer"
  ingress_class_name       = "nginx"
  kafka_ingress_class_name = "nginx"

  namespace = "lsdmesp"

  strimzi = true

  monitoring = var.enable-monitoring

  army_knife = {
    enabled  = var.enable-army-knife
    replicas = 1
  }

  strimzi_storage_class = "standard"

  depends_on = [
    module.ingress-nginx,
    module.cert-manager,
    module.observe
  ]
}
