provider "google" {
  project = var.project_id
  region  = var.region
}

provider "vault" {
  # Uses VAULT_ADDR and VAULT_TOKEN from environment variables
}
