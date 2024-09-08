

# Defining the Kubernetes namespace where ArgoCD will be deployed.
# The namespace is named "argo" and will be used throughout the deployment.
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argo"
  }
}

# Defining the deployment of ArgoCD via Helm. i'm using the Helm provider to automate
# the deployment process and ensure ArgoCD is installed in the cluster.
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.5.2"

    #  Here, i'm setting the ArgoCD admin password using a Terraform variable.
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_admin_password
  }

  # Any additional configuration for ArgoCD can be specified through the values.yaml file.
  # It can include resource limits, logging configurations, and other ArgoCD settings.
  values = [
    file("${path.module}/values.yaml")
  ]

  # Here i'm ensuring that the Helm release depends on the creation of the Kubernetes namespace,
  # so the namespace will be created before deploying ArgoCD.
  depends_on = [kubernetes_namespace.argocd]
}