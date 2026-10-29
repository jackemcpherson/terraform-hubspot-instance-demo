variable "northstar_contact_segment_label" {
  description = "Optional run- and engine-scoped label appended to every Northstar Contact segment name. Empty uses the plain names."
  type        = string
  default     = ""

  validation {
    condition = var.northstar_contact_segment_label == "" || (
      startswith(var.northstar_contact_segment_label, "ns_") &&
      length(var.northstar_contact_segment_label) <= 40 &&
      length(regexall("[^0-9A-Za-z_]", var.northstar_contact_segment_label)) == 0
    )
    error_message = "northstar_contact_segment_label must be empty or an ns_ label of at most 40 letters, digits, and underscores."
  }
}

variable "northstar_contact_segment_snapshot_excluded_email" {
  description = "Email address the contactable snapshot excludes. Changing it replaces the snapshot definition."
  type        = string
  default     = "suppressed@example.com"

  validation {
    condition     = can(regex("^[^[:space:]@]+@[^[:space:]@]+$", var.northstar_contact_segment_snapshot_excluded_email))
    error_message = "northstar_contact_segment_snapshot_excluded_email must be one email address without whitespace."
  }
}

locals {
  northstar_contact_segment_name_suffix = var.northstar_contact_segment_label == "" ? "" : " ${var.northstar_contact_segment_label}"

  # Predicates reference only existing Contact properties: the managed
  # ns_onboarding_status select and HubSpot's built-in email text property.
  # The demo never manages memberships or Contact record values.
  northstar_contact_segments = {
    all_contacts = {
      name            = "Northstar all contacts${local.northstar_contact_segment_name_suffix}"
      processing_type = "manual"
      filter_groups   = []
    }
    completed_onboarding = {
      name            = "Northstar completed onboarding${local.northstar_contact_segment_name_suffix}"
      processing_type = "dynamic"
      filter_groups = [{
        filters = [{
          property      = "ns_onboarding_status"
          operator      = "is_equal_to"
          property_kind = "select"
          value         = "complete"
        }]
      }]
    }
    contactable_snapshot = {
      name            = "Northstar contactable snapshot${local.northstar_contact_segment_name_suffix}"
      processing_type = "snapshot"
      filter_groups = [{
        filters = [{
          property      = "email"
          operator      = "is_not_equal_to"
          property_kind = "text"
          value         = var.northstar_contact_segment_snapshot_excluded_email
        }]
      }]
    }
  }
}

module "contact_segments" {
  source = "./modules/contact-segment-definition"

  definitions = local.northstar_contact_segments

  # Filters name ns_onboarding_status as a string, so neither engine can infer
  # that the property must exist before create and outlive destroy.
  depends_on = [module.crm_schema]
}
