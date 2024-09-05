variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The region where GKE resources will be deployed"
  type        = string
  default     = "europe-west2"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "sre-tech-challenge-dev-cluster"
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for the cluster nodes"
  type        = string
  default     = "e2-medium"
}

variable "credentials_file" {
  description = "The file path to the Google Cloud SA credentials"
  type        = string
}

variable "service_account_email" {
  description = "The email of the SA used by Terraform"
  type        = string
}
