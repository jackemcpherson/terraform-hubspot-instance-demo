output "ids" {
  description = "Generated HubSpot form IDs keyed by stable local form identity."
  value       = { for key, form in hubspot_form_definition.this : key => form.id }
}
