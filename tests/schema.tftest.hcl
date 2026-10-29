mock_provider "hubspot" {
  mock_resource "hubspot_file_folder" {
    defaults = {
      id         = "10001"
      path       = "/Northstar"
      created_at = "2026-08-09T00:00:00Z"
      updated_at = "2026-08-09T00:00:00Z"
    }
  }

  mock_resource "hubspot_file" {
    defaults = {
      id                  = "20001"
      path                = "/Northstar/file.txt"
      file_md5            = "d41d8cd98f00b204e9800998ecf8427e"
      size                = 1
      url                 = "https://example.invalid/file.txt"
      default_hosting_url = "https://example.invalid/file.txt"
      created_at          = "2026-08-09T00:00:00Z"
      updated_at          = "2026-08-09T00:00:00Z"
    }
  }

  mock_resource "hubspot_form_definition" {
    defaults = {
      id = "00000000-0000-4000-8000-000000000001"
    }
  }

  mock_resource "hubspot_account_membership" {
    defaults = {
      id          = "123456789"
      super_admin = false
    }
  }

  mock_resource "hubspot_product" {
    defaults = {
      id = "70001"
    }
  }

  mock_resource "hubspot_contact_segment" {
    defaults = {
      id = "80001"
    }
  }

  mock_data "hubspot_property_definition" {
    defaults = {
      id         = "contacts/email"
      label      = "Email"
      field_type = "text"
    }
  }

  mock_data "hubspot_property_definitions" {
    defaults = {
      definitions = {}
    }
  }
}

run "applies_cumulative_configuration" {
  command = apply

  variables {
    northstar_membership_email                        = "northstar-operator@example.com"
    northstar_contact_segment_label                   = ""
    northstar_contact_segment_snapshot_excluded_email = "suppressed@example.com"
  }

  assert {
    condition     = toset(keys(local.schemas)) == toset(["contacts", "companies", "deals", "tickets"])
    error_message = "The demo must cover all four supported CRM object types."
  }

  assert {
    condition = (
      keys(module.product_definitions.ids) == ["northstar_support"] &&
      output.northstar_support_product_id == module.product_definitions.ids["northstar_support"] &&
      output.northstar_product_ids == module.product_definitions.ids
    )
    error_message = "The cumulative demo must expose one stable-keyed standard Product definition."
  }

  assert {
    condition = (
      toset(keys(module.contact_segments.ids)) == toset(["all_contacts", "completed_onboarding", "contactable_snapshot"]) &&
      output.northstar_contact_segment_ids == module.contact_segments.ids &&
      output.northstar_all_contacts_segment_id == module.contact_segments.ids["all_contacts"] &&
      output.northstar_completed_onboarding_segment_id == module.contact_segments.ids["completed_onboarding"] &&
      output.northstar_contactable_snapshot_segment_id == module.contact_segments.ids["contactable_snapshot"]
    )
    error_message = "The cumulative demo must expose stable-keyed manual, dynamic, and snapshot Contact segment IDs."
  }

  assert {
    condition = (
      { for key, definition in local.northstar_contact_segments : key => definition.processing_type } == {
        all_contacts         = "manual"
        completed_onboarding = "dynamic"
        contactable_snapshot = "snapshot"
      } &&
      local.northstar_contact_segments["all_contacts"].name == "Northstar all contacts" &&
      local.northstar_contact_segments["contactable_snapshot"].name == "Northstar contactable snapshot" &&
      local.northstar_contact_segments["contactable_snapshot"].filter_groups[0].filters[0].value == "suppressed@example.com"
    )
    error_message = "Without a run label the demo must use the plain Northstar Contact segment names."
  }

  assert {
    condition = alltrue(flatten([
      for definition in values(local.northstar_contact_segments) : [
        for group in definition.filter_groups : [
          for filter in group.filters : contains(["email", "ns_onboarding_status"], filter.property)
        ]
      ]
    ]))
    error_message = "Contact segment predicates must reference existing Contact text and select properties only."
  }

  assert {
    condition     = alltrue([for schema in values(local.schemas) : length(schema.groups) > 0 && length(schema.properties) > 0])
    error_message = "Every object type must own meaningful groups and properties."
  }

  assert {
    condition     = alltrue([for schema in values(local.schemas) : alltrue([for property in values(schema.properties) : contains(["text", "select"], try(property.kind, "text"))])])
    error_message = "The cumulative demo must use only text and select property kinds."
  }

  assert {
    condition     = length(module.crm_schema["contacts"].properties) == 3 && length(module.crm_schema["tickets"].groups) == 1
    error_message = "Module outputs must expose stable property and group identities."
  }

  assert {
    condition     = keys(module.forms.ids) == ["contact_us"] && output.northstar_contact_form_id == module.forms.ids["contact_us"]
    error_message = "The cumulative demo must expose the generated Form ID through its stable module key."
  }

  assert {
    condition = (
      keys(module.account_memberships.ids) == ["northstar_operator"] &&
      output.northstar_operator_membership_id == module.account_memberships.ids["northstar_operator"] &&
      output.northstar_account_membership_ids == module.account_memberships.ids
    )
    error_message = "The cumulative demo must expose one guarded membership with welcome email disabled."
  }

  assert {
    condition = (
      keys(module.files_root.folder_ids) == ["brand"] &&
      keys(module.files_root.file_ids) == ["private_readme"] &&
      keys(module.files_brand.folder_ids) == ["downloads"] &&
      keys(module.files_brand.file_ids) == ["public_logo"]
    )
    error_message = "The cumulative demo must compose two explicit Files levels with two stable-keyed Managed files."
  }

  assert {
    condition = (
      module.files_root.folder_ids["brand"] == output.northstar_file_folder_ids["brand"] &&
      module.files_brand.folder_ids["downloads"] == output.northstar_file_folder_ids["downloads"] &&
      module.files_root.file_ids["private_readme"] == output.northstar_file_ids["private_readme"] &&
      module.files_brand.file_ids["public_logo"] == output.northstar_file_ids["public_logo"]
    )
    error_message = "The cumulative demo must expose every generated Files ID through stable module outputs."
  }
}

run "bounds_protected_files_names_for_live_search" {
  command = plan

  variables {
    northstar_files_prefix     = "ns_1a2b3c4d_o_"
    northstar_membership_email = "northstar-operator@example.com"
  }

  assert {
    condition = (
      local.northstar_files_names.brand == "ns_1a2b3c4d_o_b" &&
      local.northstar_files_names.downloads == "ns_1a2b3c4d_o_d" &&
      local.northstar_files_names.private_file == "ns_1a2b3c4d_o_p.txt" &&
      local.northstar_files_names.public_file == "ns_1a2b3c4d_o_l.svg" &&
      alltrue([for name in values(local.northstar_files_names) : length(name) <= 19])
    )
    error_message = "Protected Northstar Files names must fit the live search API's 20-character name limit."
  }
}

run "scopes_contact_segment_names_and_revision" {
  command = plan

  variables {
    northstar_membership_email                        = "northstar-operator@example.com"
    northstar_contact_segment_label                   = "ns_1a2b_tofu_revised"
    northstar_contact_segment_snapshot_excluded_email = "suppressed-revised@example.com"
  }

  assert {
    condition = (
      local.northstar_contact_segments["all_contacts"].name == "Northstar all contacts ns_1a2b_tofu_revised" &&
      local.northstar_contact_segments["completed_onboarding"].name == "Northstar completed onboarding ns_1a2b_tofu_revised" &&
      local.northstar_contact_segments["contactable_snapshot"].name == "Northstar contactable snapshot ns_1a2b_tofu_revised" &&
      local.northstar_contact_segments["contactable_snapshot"].filter_groups[0].filters[0].value == "suppressed-revised@example.com"
    )
    error_message = "A run label must scope every Contact segment name and the revision must change the snapshot filter."
  }
}

run "rejects_unbounded_contact_segment_label" {
  command = plan

  variables {
    northstar_membership_email      = "northstar-operator@example.com"
    northstar_contact_segment_label = "tofu revised"
  }

  expect_failures = [var.northstar_contact_segment_label]
}
