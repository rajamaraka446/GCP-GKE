variable "project_id" {
  type = string
}

variable "region" {
  default = "us-central1"
}

variable "secondary_region" {
  default = "us-east1"
}

variable "network_name" {
  default = "iris-production-vpc"
}

variable "primary_subnet_cidr" {
  default = "10.10.0.0/20"
}

variable "secondary_subnet_cidr" {
  default = "10.20.0.0/20"
}

variable "pod_range_primary" {
  default = "10.30.0.0/16"
}

variable "service_range_primary" {
  default = "10.40.0.0/20"
}

variable "pod_range_secondary" {
  default = "10.50.0.0/16"
}

variable "service_range_secondary" {
  default = "10.60.0.0/20"
}
