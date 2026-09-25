variable "network_name" {}
variable "region" {}
variable "secondary_region" {}

variable "primary_subnet_cidr" {}
variable "secondary_subnet_cidr" {}

variable "pod_range_primary" {}
variable "service_range_primary" {}

variable "pod_range_secondary" {}
variable "service_range_secondary" {}

variable "lb_subnet_cidr_primary" {}
variable "lb_subnet_cidr_secondary" {}
variable "ops_subnet_cidr_primary" {}
variable "ops_subnet_cidr_secondary" {}
variable "nat_ip_count_primary" {}
variable "nat_ip_count_secondary" {}
