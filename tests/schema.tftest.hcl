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

  assert {
    condition     = toset(keys(local.schemas)) == toset(["contacts", "companies", "deals", "tickets"])
    error_message = "The demo must cover all four supported CRM object types."
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
