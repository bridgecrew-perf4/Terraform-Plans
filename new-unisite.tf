terraform {
  required_providers {
    google-beta = {
      source = "hashicorp/google-beta"
      version = "3.51.0"
    }
  }
  required_version = ">= 0.13"
}

provider "google-beta" {
  credentials          = file(var.credentials_file)
  project              = var.project
  region               = "us-west1"
  zone                 = "us-west1-b"
}

// Create Network
resource "google_compute_network" "net" {
  provider             = google-beta
  name                 = var.name
  routing_mode         = "GLOBAL"
  description          = "Default Network for ${var.name}."
}

//Create VM Instance
resource "google_compute_instance_from_machine_image" "vm" {
  provider 	           = google-beta
  name                 = var.name
  machine_type         = "e2-medium"
  zone                 = "us-west1-b"
  project              = var.project
  source_machine_image = "projects/rising-goal-259700/global/machineImages/${var.image_name}"
  tags                 = ["http-server", "https-server", "bitrix", "unisite"]
  network_interface {
    network = var.name
    access_config {
      // Ephemeral IP
    }
  }
}

//Create Firewall Rules
resource "google_compute_firewall" "fw" {
  provider             = google-beta
  project              = var.project
  name                 = var.name
  network              = var.name

  allow {
    protocol      = "tcp"
    ports         = ["80", "443", "8888", "10000", "20000"]
  }
  target_tags     = ["bitrix"]
}

