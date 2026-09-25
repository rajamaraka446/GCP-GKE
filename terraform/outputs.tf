output "vpc_name" {
  value = module.networking.vpc_name
}

output "primary_subnet" {
  value = module.networking.primary_subnet
}

output "secondary_subnet" {
  value = module.networking.secondary_subnet
}
