# Defining the Kubernetes namespace where ArgoCD will be deployed.
# The namespace is named "argo" and will be used throughout the deployment.
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argo"
  }
}

# Defining the deployment of ArgoCD via Helm. I'm using the Helm provider to automate
# the deployment process and ensure ArgoCD is installed in the cluster.
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.5.2"

  # Here, I'm setting the ArgoCD admin password using a Terraform variable.
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_admin_password
  }

  # Any additional configuration for ArgoCD can be specified through the values.yaml file.
  # It can include resource limits, logging configurations, and other ArgoCD settings.
  values = [
    file("${path.module}/values.yaml")
  ]

  # Here I'm ensuring that the Helm release depends on the creation of the Kubernetes namespace,
  # so the namespace will be created before deploying ArgoCD.
  depends_on = [kubernetes_namespace.argocd]
}

# Defining the Role for Prometheus to access PodMonitors and ServiceMonitors in the argo namespace.
# This role will give Prometheus the permissions to get, list, and watch these resources.
resource "kubernetes_role" "prometheus_argo_role" {
  metadata {
    name      = "prometheus-argo-role"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  # The role allows Prometheus to perform get, list, and watch on podmonitors and servicemonitors.
  rule {
    api_groups = ["monitoring.coreos.com"]
    resources  = ["podmonitors", "servicemonitors"]
    verbs      = ["get", "list", "watch"]
  }
}

# Creating a RoleBinding to bind the above Role to Prometheus's ServiceAccount.
# This binding ensures that Prometheus can access the necessary resources in the argo namespace.
resource "kubernetes_role_binding" "prometheus_argo_rolebinding" {
  metadata {
    name      = "prometheus-argo-rolebinding"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  # This subject refers to the Prometheus ServiceAccount. Make sure the name and namespace match your setup.
  subject {
    kind      = "ServiceAccount"
    name      = "prometheus-kube-prometheus-stack-prometheus"  # Update with the correct Prometheus ServiceAccount name
    namespace = "observability"  # Replace with the namespace where Prometheus is running
  }

  # This binds the role to the Prometheus ServiceAccount.
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.prometheus_argo_role.metadata[0].name
  }
}

# Defining the ArgoCD Application for Keycloak by applying the keycloak-app.yaml file.
# This resource uses a Kubernetes manifest to deploy Keycloak via ArgoCD.
resource "kubernetes_manifest" "keycloak_app" {
  manifest = yamldecode(file("${path.module}/apps/keycloak/keycloak-app.yaml"))

  # Ensure ArgoCD is installed first before applying the Keycloak Application.
  depends_on = [helm_release.argocd]
}

# Defining the ArgoCD Application for Keycloak's realm configuration by applying the myrealm-config.yaml file.
# This resource applies the Keycloak realm configuration via a Kubernetes manifest.
resource "kubernetes_manifest" "keycloak_realm" {
  manifest = yamldecode(file("${path.module}/apps/keycloak/myrealm-config.yaml"))

  depends_on = [helm_release.argocd]
}
