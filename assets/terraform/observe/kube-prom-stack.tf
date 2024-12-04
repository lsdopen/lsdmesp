provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  debug = true
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "lsdmesp-monitoring-namespace" {
  metadata {
    name = "openshift-user-workload-monitoring"
  }
}

resource "kubernetes_labels" "lsdmesp-monitoring-namespace_labels" {
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = kubernetes_namespace.lsdmesp-monitoring-namespace.metadata[0].name
  }
  labels = {
    "openshift.io/user-monitoring" = "true"
  }
}

resource "helm_release" "lsdmesp-monitoring" {
  name       = "lsdmesp-monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  namespace = kubernetes_namespace.lsdmesp-monitoring-namespace.metadata[0].name

  values = [
    file("./values-lsdmesp.yaml")
  ]
}
