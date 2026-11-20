output "dev_vpc_name" {
  description = "Name of the dev VPC"
  value       = module.network.vpc_name
}

output "dev_subnet_id" {
  description = "ID of the dev subnet"
  value       = module.network.subnet_id
}

output "dev_vm_name" {
  description = "Name of the dev VM"
  value       = module.compute.vm_name
}

output "dev_vm_internal_ip" {
  description = "Internal IP of the dev VM"
  value       = module.compute.vm_internal_ip
}

output "dev_service_account_email" {
  description = "Service account email for dev"
  value       = module.iam.service_account_email
}

output "dev_bucket_name" {
  description = "GCS bucket name for dev"
  value       = module.storage.bucket_name
}
