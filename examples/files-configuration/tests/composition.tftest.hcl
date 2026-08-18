mock_provider "hubspot" {
  mock_resource "hubspot_file_folder" {
    defaults = { id = "1001" }
  }
  mock_resource "hubspot_file" {
    defaults = {
      id                  = "2001"
      path                = "/northstar/file"
      file_md5            = "098f6bcd4621d373cade4e832627b4f6"
      size                = 4
      url                 = "https://example.test/northstar/file"
      default_hosting_url = "https://cdn.example.test/northstar/file"
    }
  }
}

run "composes_generated_folder_ids_into_hierarchy_dependencies" {
  command = apply

  assert {
    condition     = keys(module.files_root.folder_ids) == ["brand"] && keys(module.files_brand.folder_ids) == ["downloads"]
    error_message = "Composed hierarchy levels must retain their stable folder keys."
  }

  assert {
    condition     = keys(module.files_root.file_ids) == ["private_readme"] && keys(module.files_brand.file_ids) == ["public_logo"]
    error_message = "Files at each composed hierarchy level must retain their stable keys."
  }

  assert {
    condition     = length(module.files_root.files) == 1 && length(module.files_brand.files) == 1
    error_message = "Each hierarchy level must expose only its bounded Managed file observations."
  }
}
