# Defining the Kubernetes namespace where keycloak will be deployed.
# The namespace is named "identity" and will be used throughout the deployment.
resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "identity"
  }
}