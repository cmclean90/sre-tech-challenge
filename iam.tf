# Granting the Terrafrom SA permissions to manage the GCS bucket.
# This is required because the SA will need to store and manage the Terraform state file in the bucket.
resource "google_storage_bucket_iam_member" "sa_bucket_access" {
  bucket = google_storage_bucket.terraform_state.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.service_account_email}"
}

# Granting the Terraform SA the role to manage the GKE cluster.
# This is required to allow the SA to create, manage, and scale the GKE cluster.
resource "google_project_iam_member" "terraform_sa_gke_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${var.service_account_email}"
}

# Granting the SA permissions to use and manage IAM roles.
# This is required if the SA needs to manage other SA and their roles.
resource "google_project_iam_member" "terraform_sa_iam_viewer" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${var.service_account_email}"
}