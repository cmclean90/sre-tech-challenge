provider "google" {
  # I'm specifying the service account credentials file and project details here so Terraform can interact with GCP.
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

provider "kubernetes" {
  # I'm configuring the Kubernetes provider to use the local kubeconfig file for authentication.
  # The config_path points to the local file that contains the cluster context information.
  config_path    = "~/.kube/config"
}

provider "helm" {
  # The Helm provider relies on the Kubernetes provider to interact with the cluster.
  # I'm pointing it to the same kubeconfig file.
  kubernetes {
    config_path    = "~/.kube/config"
  }
}