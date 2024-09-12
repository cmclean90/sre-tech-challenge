# Outputting the URLs for the Prometheus and Grafana services
# These values can be referenced by other resources
output "prometheus_server_url" {
  value = "http://prometheus-server.${kubernetes_namespace.observability.metadata[0].name}.svc.cluster.local"
}

output "grafana_server_url" {
  value = "http://grafana.${kubernetes_namespace.observability.metadata[0].name}.svc.cluster.local"
}
