output "network_name" {
  value = google_compute_network.custom_network.name
}

output "subnetwork_name" {
  value = google_compute_subnetwork.custom_subnetwork.name
}