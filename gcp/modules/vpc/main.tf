resource "google_compute_network" "custom_network" {
  name                    = "custom-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom_subnetwork" {
  name          = "custom-subnetwork"
  network       = google_compute_network.custom_network.name
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.custom_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}