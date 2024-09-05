# I'm outputting the name of the cluster for reference in other resources.
output "kubernetes_cluster_name" {
  description = "The name of the Kubernetes cluster"
  value       = google_container_cluster.primary.name
}