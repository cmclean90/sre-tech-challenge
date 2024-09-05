# This Terraform configuration defines and provisions a GKE cluster.
resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.region
  initial_node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  # i'm enabling IP aliasing here because it helps with managing network resources more effectively.
  # This is generally a good practice for most GKE setups.
  ip_allocation_policy {}
}

# Defining the node pool for the cluster.
resource "google_container_node_pool" "primary_nodes" {
  cluster  = google_container_cluster.primary.name
  location = google_container_cluster.primary.location
  name     = "primary-node-pool"

  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  # I've set up autoscaling here so the cluster can adjust the number of nodes based on the workload and keep costs down when nessessary.
  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }
}