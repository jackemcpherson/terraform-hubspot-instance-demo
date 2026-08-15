output "ids" {
  description = "Canonical CRM user IDs keyed by stable local profile identity."
  value       = { for key, profile in hubspot_crm_user_profile.this : key => profile.id }
}
