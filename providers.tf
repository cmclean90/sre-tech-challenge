provider "google" {
  # I'm specifying the service account credentials file and project details here so Terraform can interact with GCP.
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}