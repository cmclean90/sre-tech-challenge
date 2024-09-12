# Create the 'observability' namespace
resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}

# Create a ConfigMap for custom Grafana dashboards and alerts
# Dashboards and alerts will be sourced from JSON/yaml files in the specified directory
# These files will be automatically picked up by Grafana's sidecar
resource "kubernetes_config_map" "custom_grafana_dashboards" {
  metadata {
    name      = "custom-grafana-dashboards"
    namespace = "observability"
  }

  # Iterate over all JSON files in the dashboards directory to include them in the ConfigMap
  data = {
    for file in fileset("${path.module}/observability/dashboards", "*.json") :
      filebasename(file) => file("${path.module}/observability/dashboards/${file}")
  }
}

resource "kubernetes_config_map" "custom_grafana_alerts" {
  metadata {
    name      = "custom-grafana-alerts"
    namespace = "observability"
  }
  # Iterate over all yaml files in the alerts directory to include them in the ConfigMap
  data = {
    for file in fileset("${path.module}/observability/alerts", "*.yaml") :
      filebasename(file) => file("${path.module}/observability/alerts/${file}")
  }
}

# ServiceMonitor for ArgoCD Server
resource "kubernetes_manifest" "argocd_server_servicemonitor" {
  manifest = yamldecode(file("${path.module}/servicemonitors/servicemonitor-argocd-server-metrics.yaml"))
  depends_on = [helm_release.kube_prometheus_stack]
}

# ServiceMonitor for ArgoCD Repo Server
resource "kubernetes_manifest" "argocd_repo_server_servicemonitor" {
  manifest = yamldecode(file("${path.module}/servicemonitors/servicemonitor-argocd-repo-server-metrics.yaml"))
  depends_on = [helm_release.kube_prometheus_stack]
}

# ServiceMonitor for ArgoCD Application Controller
resource "kubernetes_manifest" "argocd_application_controller_servicemonitor" {
  manifest = yamldecode(file("${path.module}/servicemonitors/servicemonitor-argocd-application-controller-metrics.yaml"))
  depends_on = [helm_release.kube_prometheus_stack]
}

# ServiceMonitor for Keycloak
resource "kubernetes_manifest" "servicemonitor-keycloak-application" {
  manifest = yamldecode(file("${path.module}/servicemonitors/servicemonitor-keycloak-application.yaml"))
  depends_on = [helm_release.kube_prometheus_stack]
}

# Deploy kube-prometheus-stack via Helm
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.observability.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "62.6.0"

  values = [
    file("${path.module}/kube-prometheus-stack-values.yaml")
  ]

  depends_on = [kubernetes_namespace.observability]
}