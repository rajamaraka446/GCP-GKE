variable "project_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "organization_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "create_folder" {
  type = bool
}

variable "create_project" {
  type = bool
}

variable "billing_account" {
  type = string
}

variable "dev_group" {
  type = string
}

variable "ops_group" {
  type = string
}

variable "sre_group" {
  type = string
}

variable "cicd_service_account" {
  type = string
}

variable "monitoring_project_id" {
  type = string
}

variable "shared_vpc_host_project_id" {
  type = string
}

variable "shared_vpc_service_projects" {
  type = set(string)
}