output "ids" {
  description = "Generated HubSpot Product IDs keyed by stable local identity."
  value       = { for key, product in hubspot_product.this : key => product.id }
}
