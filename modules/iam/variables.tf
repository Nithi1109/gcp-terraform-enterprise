variable "account_id" {
  description = "Service account ID"
  type        = string
}

variable "display_name" {
  description = "Display name for the service account"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "role" {
  description = "IAM role to grant"
  type        = string
  default     = "roles/logging.logWriter"
}
