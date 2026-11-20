locals {
  env = "dev"
}

resource "google_project_service" "compute_api" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam_api" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "storage_api" {
  project            = var.project_id
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

module "network" {
  source = "../../modules/network"

  network_name = "${local.env}-vpc"
  subnet_name  = "${local.env}-subnet"
  subnet_cidr  = "10.10.1.0/24"
  region       = var.region

  depends_on = [google_project_service.compute_api]
}

module "compute" {
  source = "../../modules/compute"

  instance_name = "${local.env}-vm-1"
  machine_type  = "e2-micro"
  zone          = "${var.region}-a"
  subnet_id     = module.network.subnet_id
  tags          = ["ssh-allowed"]

  depends_on = [module.network]
}

module "iam" {
  source = "../../modules/iam"

  account_id   = "${local.env}-app-sa"
  display_name = "Dev Application Service Account"
  project_id   = var.project_id
  role         = "roles/logging.logWriter"

  depends_on = [google_project_service.iam_api]
}

module "storage" {
  source = "../../modules/storage"

  bucket_name = "${var.project_id}-${local.env}-artifacts-bucket"
  location    = var.region
  project_id  = var.project_id

  depends_on = [google_project_service.storage_api]
}
