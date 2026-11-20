output "vm_name" {
  description = "VM instance name"
  value       = google_compute_instance.vm.name
}

output "vm_internal_ip" {
  description = "VM internal IP address"
  value       = google_compute_instance.vm.network_interface[0].network_ip
}
