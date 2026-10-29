output "ids" {
  description = "Generated HubSpot ILS list IDs keyed by stable local Contact segment identity."
  value       = { for key, segment in hubspot_contact_segment.this : key => segment.id }
}
