terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {

  credentials = file("keys/CloudTesting.json")

  project = "rising-goal-259700"
  region  = "us-west1"
  zone    = "us-west1-b"
}

module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "2.0.2"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
