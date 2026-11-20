variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the primary subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "IP CIDR range for the subnet"
  type        = string
}

variable "region" {
  description = "GCP region for the subnet"
  type        = string
}
