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
  version = "1.5.7"

  cluster_name             = "kind"
  base_url                 = "apps.mesp.lsdopen.io"
  cluster_issuer_name      = "issuer"
  ingress_class_name       = "nginx"
  kafka_ingress_class_name = "nginx"

  confluent_kafka = {
    enabled  = true
    username = "cf_kafka"
    ingress  = true
  }
  confluent_connect = {
    enabled  = true
    username = "cf_connect"
    ingress  = true
  }
  confluent_controlcenter = {
    enabled  = true
    username = "cf_controlcenter"
    ingress  = true
  }
  confluent_ksqldb = {
    enabled  = true
    username = "cf_ksqldb"
    ingress  = true
  }
  confluent_schemaregistry = {
    enabled  = true
    username = "cf_schemaregistry"
    ingress  = true
  }

  namespace = "lsdmesp"

  confluent = true

  confluent_demo = {
    enabled = true
  }

  monitoring = var.enable-monitoring

  army_knife = {
    enabled  = var.enable-army-knife
    replicas = 1
  }

  confluent_ldap = {
    enabled                 = true
    organisation            = "Test Inc."
    domain                  = "test.com"
    admin_password          = "confluentrox"
    config_password         = "confluentconfigrox"
    read_only_user_username = "mds"
    read_only_user_password = "Developer!"
    base_dn                 = "dc=test,dc=com"
  }

  confluent_storage_class = "standard"

  depends_on = [
    module.ingress-nginx,
    module.cert-manager,
    module.observe
  ]
}
