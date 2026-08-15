# Manages CRM user profile properties through stable local keys.
resource "hubspot_crm_user_profile" "this" {
  for_each = var.profiles

  account_membership_id = each.value.account_membership_id
  job_title             = each.value.job_title
  availability_status   = each.value.availability_status
  time_zone             = each.value.time_zone
  working_hours         = each.value.working_hours
}
