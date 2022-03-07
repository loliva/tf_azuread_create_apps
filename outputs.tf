output "azure_domain" {
  value = data.azuread_domains.current.domains[0].domain_name
}
output "azure_id" {
  value       = data.azuread_client_config.current.id
}
