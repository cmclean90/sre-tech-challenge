# Define the Kubernetes namespace for Keycloak deployment.
resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "identity"
  }
}