output "ids" {
  description = "Canonical HubSpot Settings user IDs keyed by stable local membership identity."
  value       = { for key, membership in hubspot_account_membership.this : key => membership.id }
}

output "super_admin" {
  description = "Observed Super Admin status keyed by stable local membership identity."
  value       = { for key, membership in hubspot_account_membership.this : key => membership.super_admin }
}
