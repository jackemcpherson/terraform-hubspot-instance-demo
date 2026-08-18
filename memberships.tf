module "account_memberships" {
  source = "./modules/account-membership"

  memberships = {
    northstar_operator = {
      email              = var.northstar_membership_email
      send_welcome_email = false
      allow_removal      = true
    }
  }
}
