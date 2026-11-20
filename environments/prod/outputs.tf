output "prod_vpc_name" {
  description = "Name of the prod VPC"
  value       = module.network.vpc_name
}

output "prod_subnet_id" {
  description = "ID of the prod subnet"
  value       = module.network.subnet_id
}

output "prod_vm_name" {
  description = "Name of the prod VM"
  value       = module.compute.vm_name
}

output "prod_service_account_email" {
  description = "Service account email for prod"
  value       = module.iam.service_account_email
}

output "prod_bucket_name" {
  description = "GCS bucket name for prod"
  value       = module.storage.bucket_name
}
