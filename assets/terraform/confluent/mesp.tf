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
  version = "1.2.1"

  cluster_name             = "kind"
  base_url                 = "apps.mesp.lsdopen.io"
  cluster_issuer_name      = "issuer"
  ingress_class_name       = "nginx"
  kafka_ingress_class_name = "nginx"

  confluent_kafka = {
    enabled  = true
    username = "cf_kafka"
    ingress  = false
  }
  confluent_connect = {
    enabled  = true
    username = "cf_connect"
    ingress  = false
  }
  confluent_controlcenter = {
    enabled  = true
    username = "cf_controlcenter"
    ingress  = false
  }
  confluent_ksqldb = {
    enabled  = true
    username = "cf_ksqldb"
    ingress  = false
  }
  confluent_schemaregistry = {
    enabled  = true
    username = "cf_schemaregistry"
    ingress  = false
  }

  namespace = "lsdmesp"

  confluent = true

  confluent_demo = {
    enabled = true
  }

  monitoring = false

  army_knife = {
    enabled  = false
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
}
