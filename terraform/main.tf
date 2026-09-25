module "platform" {
  source = "./modules/platform"

  project_id                  = var.project_id
  project_name                = var.project_name
  organization_id             = var.organization_id
  folder_id                   = var.folder_id
  create_folder               = var.create_folder
  create_project              = var.create_project
  billing_account             = var.billing_account
  dev_group                   = var.dev_group
  ops_group                   = var.ops_group
  sre_group                   = var.sre_group
  cicd_service_account        = var.cicd_service_account
  monitoring_project_id       = var.monitoring_project_id
  shared_vpc_host_project_id  = var.shared_vpc_host_project_id
  shared_vpc_service_projects = var.shared_vpc_service_projects
}

module "networking" {
  source = "./modules/networking"

  depends_on = [module.platform]

  network_name     = var.network_name
  region           = var.region
  secondary_region = var.secondary_region

  primary_subnet_cidr   = var.primary_subnet_cidr
  secondary_subnet_cidr = var.secondary_subnet_cidr

  pod_range_primary     = var.pod_range_primary
  service_range_primary = var.service_range_primary

  pod_range_secondary       = var.pod_range_secondary
  service_range_secondary   = var.service_range_secondary
  lb_subnet_cidr_primary    = var.lb_subnet_cidr_primary
  lb_subnet_cidr_secondary  = var.lb_subnet_cidr_secondary
  ops_subnet_cidr_primary   = var.ops_subnet_cidr_primary
  ops_subnet_cidr_secondary = var.ops_subnet_cidr_secondary
  nat_ip_count_primary      = var.nat_ip_count_primary
  nat_ip_count_secondary    = var.nat_ip_count_secondary
}

module "customer_traffic" {
  source = "./modules/customer-traffic"

  depends_on = [module.platform]

  project_id      = var.project_id
  customer_domain = var.customer_domain
  dns_zone_name   = var.dns_zone_name
}

module "observability" {
  source = "./modules/observability"

  depends_on = [module.platform, module.networking]

  project_id                = var.project_id
  customer_domain           = var.customer_domain
  network_name              = var.network_name
  bigquery_dataset_id       = var.observability_bigquery_dataset_id
  enable_grafana            = var.enable_grafana
  grafana_region            = var.region
  grafana_zone              = var.grafana_zone
  enable_managed_prometheus = var.enable_managed_prometheus
}
