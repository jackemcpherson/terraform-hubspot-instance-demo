output "managed_schema" {
  description = "Managed HubSpot CRM groups and property names by object type."
  value = {
    for object_type, schema in local.schemas : object_type => {
      groups     = module.crm_schema[object_type].groups
      properties = module.crm_schema[object_type].properties
    }
  }
}

output "observed_managed_properties" {
  description = "Managed property names read back through the collection data source."
  value = {
    for object_type, schema in local.schemas : object_type => sort([
      for property_name in keys(data.hubspot_property_definitions.observed[object_type].definitions) : property_name
      if contains(keys(schema.properties), property_name)
    ])
  }
}

output "builtin_email_property" {
  description = "A built-in contact property read through the singular data source."
  value = {
    name       = data.hubspot_property_definition.builtin_email.name
    label      = data.hubspot_property_definition.builtin_email.label
    field_type = data.hubspot_property_definition.builtin_email.field_type
  }
}

output "northstar_form_ids" {
  description = "Generated HubSpot form IDs keyed by stable local form identity."
  value       = module.forms.ids
}

output "northstar_contact_form_id" {
  description = "Generated identity of the stable-keyed Northstar contact form."
  value       = module.forms.ids["contact_us"]
}

output "northstar_account_membership_ids" {
  description = "Canonical HubSpot Settings user IDs keyed by stable Northstar membership identity."
  value       = module.account_memberships.ids
}

output "northstar_operator_membership_id" {
  description = "Canonical Settings user ID of the stable-keyed Northstar operator membership."
  value       = module.account_memberships.ids["northstar_operator"]
}

output "northstar_crm_user_profile_ids" {
  description = "Canonical CRM user IDs keyed by stable Northstar profile identity."
  value       = module.crm_user_profiles.ids
}

output "northstar_operator_crm_profile_id" {
  description = "Canonical account-specific CRM user ID for the Northstar operator profile."
  value       = module.crm_user_profiles.ids["northstar_operator"]
}

output "northstar_file_folder_ids" {
  description = "Generated HubSpot File folder IDs keyed by stable Northstar folder identity."
  value = {
    brand     = module.files_root.folder_ids["brand"]
    downloads = module.files_brand.folder_ids["downloads"]
  }
}

output "northstar_file_ids" {
  description = "Generated HubSpot Managed file IDs keyed by stable Northstar file identity."
  value = {
    private_readme = module.files_root.file_ids["private_readme"]
    public_logo    = module.files_brand.file_ids["public_logo"]
  }
}

output "northstar_brand_folder_id" {
  description = "Generated identity of the stable-keyed Northstar brand folder."
  value       = module.files_root.folder_ids["brand"]
}

output "northstar_downloads_folder_id" {
  description = "Generated identity of the stable-keyed Northstar downloads folder."
  value       = module.files_brand.folder_ids["downloads"]
}

output "northstar_private_file_id" {
  description = "Generated identity of the stable-keyed Northstar private Managed file."
  value       = module.files_root.file_ids["private_readme"]
}

output "northstar_public_file_id" {
  description = "Generated identity of the stable-keyed Northstar public non-indexable Managed file."
  value       = module.files_brand.file_ids["public_logo"]
}
