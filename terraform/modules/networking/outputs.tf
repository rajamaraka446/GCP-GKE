output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "primary_subnet" {
  value = google_compute_subnetwork.primary.name
}

output "secondary_subnet" {
  value = google_compute_subnetwork.secondary.name
}

output "primary_pod_range" {
  value = google_compute_subnetwork.primary.secondary_ip_range[0].range_name
}

output "primary_service_range" {
  value = google_compute_subnetwork.primary.secondary_ip_range[1].range_name
}

output "secondary_pod_range" {
  value = google_compute_subnetwork.secondary.secondary_ip_range[0].range_name
}

output "secondary_service_range" {
  value = google_compute_subnetwork.secondary.secondary_ip_range[1].range_name
}

output "lb_primary_subnet" {
  value = google_compute_subnetwork.lb_primary.name
}

output "lb_secondary_subnet" {
  value = google_compute_subnetwork.lb_secondary.name
}

output "ops_primary_subnet" {
  value = google_compute_subnetwork.ops_primary.name
}

output "ops_secondary_subnet" {
  value = google_compute_subnetwork.ops_secondary.name
}
