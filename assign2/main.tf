# Provider Configuration
provider "google" {
  credentials = file("D:/Durham College/Semester-2/Deploying Cloud Infrastructure/Lab-4/credentials.json")
  project     = "i-freedom-412206"
  region      = "us-central1"
}

# VPC
resource "google_compute_network" "vpc_network" {
  name = "lab4-vpc"
}

# Subnets
resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-central1"
}

# Compute Engine Instance
resource "google_compute_instance" "agrawal-instance" {
  name         = "agrawal-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.self_link
    access_config {
      // Allocate a public IP address
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    docker run -d -p 80:5000 --name my-flask-app gcr.io/i-freedom-412206/my-flask-image

 	

  EOF
}

# Firewall Rule
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}
