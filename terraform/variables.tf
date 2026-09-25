variable "project_id" {
  type = string
}

variable "project_name" {
  description = "Display name used when Terraform creates the project."
  type        = string
  default     = "Iris GKE Production"
}

variable "organization_id" {
  description = "Numeric Google Cloud organization ID, used when creating a folder."
  type        = string
  default     = ""
}

variable "folder_id" {
  description = "Existing folder ID such as folders/123456789012."
  type        = string
  default     = ""
}

variable "create_folder" {
  type    = bool
  default = false
}

variable "create_project" {
  description = "Create the project instead of managing an already-existing project."
  type        = bool
  default     = false
}

variable "billing_account" {
  description = "Billing account ID required when create_project is true."
  type        = string
  default     = ""
}

variable "dev_group" {
  description = "Google Group email for developers."
  type        = string
  default     = ""
}

variable "ops_group" {
  description = "Google Group email for operations."
  type        = string
  default     = ""
}

variable "sre_group" {
  description = "Google Group email for SRE."
  type        = string
  default     = ""
}

variable "cicd_service_account" {
  description = "CI/CD service account email."
  type        = string
  default     = ""
}

variable "monitoring_project_id" {
  description = "Optional metrics-scope project for centralized Cloud Monitoring."
  type        = string
  default     = ""
}

variable "shared_vpc_host_project_id" {
  description = "Optional Shared VPC host project ID."
  type        = string
  default     = ""
}

variable "shared_vpc_service_projects" {
  description = "Optional projects attached to the Shared VPC host."
  type        = set(string)
  default     = []
}

variable "customer_domain" {
  description = "Public hostname served by the global GKE Multi-Cluster Ingress."
  type        = string
  default     = "app.example.com"
}

variable "dns_zone_name" {
  description = "Cloud DNS managed zone name without a trailing dot."
  type        = string
  default     = "example.com"
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

variable "lb_subnet_cidr_primary" {
  description = "Regional proxy-only subnet for load balancers in the primary region."
  type        = string
  default     = "10.70.0.0/24"
}

variable "lb_subnet_cidr_secondary" {
  description = "Regional proxy-only subnet for load balancers in the secondary region."
  type        = string
  default     = "10.70.1.0/24"
}

variable "ops_subnet_cidr_primary" {
  description = "Operations and monitoring subnet in the primary region."
  type        = string
  default     = "10.80.0.0/24"
}

variable "ops_subnet_cidr_secondary" {
  description = "Operations and monitoring subnet in the secondary region."
  type        = string
  default     = "10.80.1.0/24"
}

variable "nat_ip_count_primary" {
  type    = number
  default = 1
}

variable "nat_ip_count_secondary" {
  type    = number
  default = 1
}

variable "observability_bigquery_dataset_id" {
  description = "BigQuery dataset receiving application and GKE log exports."
  type        = string
  default     = "gke_observability"
}

variable "enable_grafana" {
  description = "Create a Cloud-hosted Managed Service for Grafana workspace."
  type        = bool
  default     = true
}

variable "grafana_zone" {
  description = "Zone used by the managed Grafana workspace."
  type        = string
  default     = "us-central1-a"
}

variable "enable_managed_prometheus" {
  description = "Enable the Google-managed Prometheus API for GKE metrics collection."
  type        = bool
  default     = true
}
