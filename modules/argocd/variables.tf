variable "argocd_namespace" {
  description = "The namespace for deploying ArgoCD"
  default     = "argo"
}

variable "argocd_admin_password" {
  description = "Hashed ArgoCD admin password"
  type        = string
}
