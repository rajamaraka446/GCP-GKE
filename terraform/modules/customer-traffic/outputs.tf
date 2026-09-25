output "global_ip_address" {
  value = google_compute_global_address.customer_traffic.address
}

output "dns_nameservers" {
  value = google_dns_managed_zone.customer_traffic.name_servers
}

output "security_policy_name" {
  value = google_compute_security_policy.customer_traffic_waf.name
}