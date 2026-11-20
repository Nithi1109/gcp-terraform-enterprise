variable "bucket_name" {
  description = "Globally unique GCS bucket name"
  type        = string
}

variable "location" {
  description = "GCP bucket location"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}
