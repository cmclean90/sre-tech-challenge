# I'm configuring the backend to store the Terraform state file in the GCS bucket.
# The state file is stored in the GCS bucket defined in 'storage-buckets.tf'.

terraform {
  backend "gcs" {
    bucket = "sre-tech-challenge-state"
    prefix = "terraform/state"
  }
}