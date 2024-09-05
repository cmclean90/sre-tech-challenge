# I'm creating a GCS bucket to store Terraform state files.
# I'm enabling versioning here to keep track of changes made to the state file,
# which allows us to recover previous versions if needed.

resource "google_storage_bucket" "terraform_state" {
  name          = "sre-tech-challenge-state"
  location      = var.region
  force_destroy = true

  versioning {
    enabled = true
  }
}
