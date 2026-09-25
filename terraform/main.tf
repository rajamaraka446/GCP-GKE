module "networking" {
  source = "./modules/networking"

  network_name           = var.network_name
  region                 = var.region
  secondary_region       = var.secondary_region

  primary_subnet_cidr    = var.primary_subnet_cidr
  secondary_subnet_cidr  = var.secondary_subnet_cidr

  pod_range_primary      = var.pod_range_primary
  service_range_primary  = var.service_range_primary

  pod_range_secondary    = var.pod_range_secondary
  service_range_secondary= var.service_range_secondary
}
