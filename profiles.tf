module "crm_user_profiles" {
  source = "./modules/crm-user-profile"

  profiles = {
    northstar_operator = {
      account_membership_id = module.account_memberships.ids["northstar_operator"]
      job_title             = "Cloud Operations Engineer"
      availability_status   = "available"
      time_zone             = "Australia/Melbourne"
      working_hours = [
        {
          days         = "MONDAY_TO_FRIDAY"
          start_minute = 540
          end_minute   = 1020
        }
      ]
    }
  }
}
