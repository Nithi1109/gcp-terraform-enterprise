resource "google_compute_instance" "vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
  }

  lifecycle {
    create_before_destroy = true
  }
}
