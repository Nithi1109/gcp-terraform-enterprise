variable "instance_name" {
  description = "Name of the Compute Engine VM"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the VM"
  type        = string
  default     = "e2-micro"
}

variable "zone" {
  description = "GCP zone for the VM"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the VM"
  type        = string
}

variable "tags" {
  description = "Network tags for firewall rules"
  type        = list(string)
  default     = ["ssh-allowed"]
}
