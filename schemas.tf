locals {
  schemas = {
    contacts = {
      groups = {
        ns_customer_context = {
          label         = "Northstar customer context"
          display_order = 100
        }
      }
      properties = {
        ns_buyer_role = {
          label         = "Buyer role"
          group         = "ns_customer_context"
          kind          = "select"
          description   = "Role this contact plays in a Northstar buying decision."
          display_order = 110
          options = {
            economic_buyer     = { label = "Economic buyer", display_order = 10 }
            champion           = { label = "Champion", display_order = 20 }
            technical_reviewer = { label = "Technical reviewer", display_order = 30 }
            end_user           = { label = "End user", display_order = 40 }
          }
        }
        ns_onboarding_status = {
          label         = "Onboarding status"
          group         = "ns_customer_context"
          kind          = "select"
          description   = "Current customer onboarding milestone."
          display_order = 120
          options = {
            not_started       = { label = "Not started", display_order = 10 }
            kickoff_scheduled = { label = "Kickoff scheduled", display_order = 20 }
            in_progress       = { label = "In progress", display_order = 30 }
            blocked           = { label = "Blocked", display_order = 40 }
            complete          = { label = "Complete", display_order = 50 }
          }
        }
        ns_last_success_review = {
          label         = "Last success review"
          group         = "ns_customer_context"
          description   = "Date of the most recent customer success review."
          display_order = 130
        }
      }
    }

    companies = {
      groups = {
        ns_account_profile = {
          label         = "Northstar account profile"
          display_order = 200
        }
      }
      properties = {
        ns_account_tier = {
          label         = "Account tier"
          group         = "ns_account_profile"
          kind          = "select"
          description   = "Service tier used for account planning."
          display_order = 210
          options = {
            strategic = { label = "Strategic", display_order = 10 }
            growth    = { label = "Growth", display_order = 20 }
            emerging  = { label = "Emerging", display_order = 30 }
          }
        }
        ns_renewal_date = {
          label         = "Renewal date"
          group         = "ns_account_profile"
          description   = "Current contract renewal date."
          display_order = 220
        }
      }
    }

    deals = {
      groups = {
        ns_commercial_context = {
          label         = "Northstar commercial context"
          display_order = 300
        }
      }
      properties = {
        ns_commercial_motion = {
          label         = "Commercial motion"
          group         = "ns_commercial_context"
          kind          = "select"
          description   = "Commercial reason for the deal."
          display_order = 310
          options = {
            new_business = { label = "New business", display_order = 10 }
            expansion    = { label = "Expansion", display_order = 20 }
            renewal      = { label = "Renewal", display_order = 30 }
          }
        }
        ns_implementation_risk = {
          label         = "Implementation risk"
          group         = "ns_commercial_context"
          kind          = "select"
          description   = "Current delivery risk assessed during qualification."
          display_order = 320
          options = {
            low    = { label = "Low", display_order = 10 }
            medium = { label = "Medium", display_order = 20 }
            high   = { label = "High", display_order = 30 }
          }
        }
      }
    }

    tickets = {
      groups = {
        ns_support_context = {
          label         = "Northstar support context"
          display_order = 400
        }
      }
      properties = {
        ns_support_priority = {
          label         = "Support priority"
          group         = "ns_support_context"
          kind          = "select"
          description   = "Northstar's authored priority classification for the ticket."
          display_order = 410
          options = {
            low      = { label = "Low", display_order = 10 }
            standard = { label = "Standard", display_order = 20 }
            urgent   = { label = "Urgent", display_order = 30 }
          }
        }
        ns_support_summary = {
          label         = "Support summary"
          group         = "ns_support_context"
          description   = "Short operational summary maintained by Northstar support."
          display_order = 420
        }
        ns_response_due_at = {
          label         = "Response due at"
          group         = "ns_support_context"
          description   = "Target time for the next Northstar support response."
          display_order = 430
        }
      }
    }
  }
}
