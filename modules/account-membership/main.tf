# Manages account membership through stable local keys and explicit safeguards.
resource "hubspot_account_membership" "this" {
  for_each = var.memberships

  email              = each.value.email
  first_name         = each.value.first_name
  last_name          = each.value.last_name
  send_welcome_email = each.value.send_welcome_email
  allow_removal      = each.value.allow_removal
}
