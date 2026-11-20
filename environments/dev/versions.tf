terraform {
  required_version = ">= 1.6.0"

  cloud {
    organization = "nithi-gcp-tf"

    workspaces {
      name = "gcp-dev"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}
