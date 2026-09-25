output "vpc_name" {
  value = module.networking.vpc_name
}

output "primary_subnet" {
  value = module.networking.primary_subnet
}

output "secondary_subnet" {
  value = module.networking.secondary_subnet
}

output "customer_traffic_ip" {
  description = "Global IP to which the customer DNS record resolves."
  value       = module.customer_traffic.global_ip_address
}

output "customer_traffic_dns_nameservers" {
  description = "Nameservers to configure at the domain registrar for the Cloud DNS zone."
  value       = module.customer_traffic.dns_nameservers
}

output "customer_traffic_security_policy" {
  description = "Cloud Armor policy attached through the Kubernetes BackendConfig."
  value       = module.customer_traffic.security_policy_name
}

output "platform_folder_id" {
  value = module.platform.folder_id
}

output "central_logging_bucket" {
  value = module.platform.logging_bucket
}

output "lb_primary_subnet" {
  value = module.networking.lb_primary_subnet
}

output "lb_secondary_subnet" {
  value = module.networking.lb_secondary_subnet
}

output "ops_primary_subnet" {
  value = module.networking.ops_primary_subnet
}

output "ops_secondary_subnet" {
  value = module.networking.ops_secondary_subnet
}

output "observability_bigquery_dataset" {
  value = module.observability.bigquery_dataset
}

output "grafana_workspace_endpoint" {
  value = module.observability.grafana_workspace_endpoint
}

output "uptime_check" {
  value = module.observability.uptime_check
}
