variable "project_id" {
  type = string
}

variable "customer_domain" {
  type = string
}

variable "network_name" {
  type = string
}

variable "bigquery_dataset_id" {
  type = string
}

variable "enable_grafana" {
  type = bool
}

variable "grafana_region" {
  type = string
}

variable "grafana_zone" {
  type = string
}

variable "enable_managed_prometheus" {
  type = bool
}