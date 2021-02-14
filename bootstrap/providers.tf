provider "google" {
  region = "us-central1"
  zone   = "us-central1-a"
}

terraform {
  required_version = "0.13.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 3.51.0"
    }
  }
}