mock_provider "hubspot" {
  mock_resource "hubspot_file_folder" {
    defaults = {
      id = "1001"
    }
  }

  mock_resource "hubspot_file" {
    defaults = {
      id                  = "2001"
      path                = "/assets/readme.txt"
      file_md5            = "098f6bcd4621d373cade4e832627b4f6"
      size                = 4
      url                 = "https://example.test/assets/readme.txt"
      default_hosting_url = "https://cdn.example.test/assets/readme.txt"
    }
  }
}

variables {
  folders = {
    assets = { name = "Assets" }
  }
  files = {
    readme = {
      name          = "readme.txt"
      source_path   = "testdata/readme.txt"
      source_sha256 = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
      folder_key    = "assets"
    }
  }
}

run "plans_stable_keys_and_safe_defaults" {
  command = apply

  assert {
    condition     = keys(hubspot_file_folder.this) == ["assets"] && keys(hubspot_file.this) == ["readme"]
    error_message = "Folder and file map keys must create stable resource addresses."
  }

  assert {
    condition     = hubspot_file_folder.this["assets"].parent_folder_id == null && hubspot_file.this["readme"].access == "PRIVATE"
    error_message = "A root hierarchy level and Managed file must expand to safe defaults."
  }

  assert {
    condition     = output.folder_ids == { assets = "1001" } && output.file_ids == { readme = "2001" }
    error_message = "Outputs must retain stable keys and expose generated identities only."
  }

  assert {
    condition = output.files == {
      readme = {
        path                = "/assets/readme.txt"
        file_md5            = "098f6bcd4621d373cade4e832627b4f6"
        size                = 4
        url                 = "https://example.test/assets/readme.txt"
        default_hosting_url = "https://cdn.example.test/assets/readme.txt"
      }
    }
    error_message = "File observations must be bounded to the documented output shape."
  }
}

run "plans_file_first_teardown" {
  command = plan

  variables {
    folders = {}
    files   = {}
  }

  assert {
    condition     = output.folder_ids == {} && output.file_ids == {} && output.files == {}
    error_message = "Removing the stable-keyed inputs must plan deletion of every Managed file and File folder."
  }
}

run "rejects_invalid_parent_folder_ids" {
  command = plan
  variables {
    parent_folder_id = "0"
    folders          = {}
    files            = {}
  }
  expect_failures = [var.parent_folder_id]
}

run "rejects_unstable_folder_keys" {
  command = plan
  variables {
    folders = { "Brand Assets" = { name = "Brand" } }
    files   = {}
  }
  expect_failures = [var.folders]
}

run "rejects_invalid_folder_names" {
  command = plan
  variables {
    folders = { assets = { name = " ../assets " } }
    files   = {}
  }
  expect_failures = [var.folders]
}

run "rejects_duplicate_child_folder_names" {
  command = plan
  variables {
    folders = {
      assets  = { name = "Assets" }
      uploads = { name = "Assets" }
    }
    files = {}
  }
  expect_failures = [var.folders]
}

run "plans_typed_parent_and_access_overrides" {
  command = apply
  variables {
    parent_folder_id = "42"
    folders          = {}
    files = {
      public_readme = {
        name          = "readme.txt"
        source_path   = "testdata/readme.txt"
        source_sha256 = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
        access        = "PUBLIC_NOT_INDEXABLE"
      }
    }
  }

  assert {
    condition     = hubspot_file.this["public_readme"].folder_id == "42" && hubspot_file.this["public_readme"].access == "PUBLIC_NOT_INDEXABLE"
    error_message = "A file without folder_key must target the explicit parent and retain its typed access override."
  }
}

run "rejects_unstable_file_keys" {
  command = plan
  variables {
    folders = { assets = { name = "Assets" } }
    files = {
      "Public readme" = {
        name          = "readme.txt"
        source_path   = "testdata/readme.txt"
        source_sha256 = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
        folder_key    = "assets"
      }
    }
  }
  expect_failures = [var.files]
}

run "rejects_invalid_file_names_and_blocked_extensions" {
  command = plan
  variables {
    folders = { assets = { name = "Assets" } }
    files = {
      installer = {
        name          = " setup.EXE "
        source_path   = "testdata/readme.txt"
        source_sha256 = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
        folder_key    = "assets"
      }
    }
  }
  expect_failures = [var.files]
}

run "rejects_invalid_file_sources_and_access" {
  command = plan
  variables {
    folders = { assets = { name = "Assets" } }
    files = {
      readme = {
        name          = "readme.txt"
        source_path   = " "
        source_sha256 = "ABC"
        folder_key    = "assets"
        access        = "HIDDEN_SENSITIVE"
      }
    }
  }
  expect_failures = [var.files]
}

run "rejects_unknown_child_folder_destinations" {
  command = plan
  variables {
    folders = { assets = { name = "Assets" } }
    files = {
      readme = {
        name          = "readme.txt"
        source_path   = "testdata/readme.txt"
        source_sha256 = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
        folder_key    = "missing"
      }
    }
  }
  expect_failures = [hubspot_file.this["readme"]]
}

run "rejects_root_files_without_a_managed_destination" {
  command = plan
  variables {
    folders = {}
    files = {
      readme = {
        name          = "readme.txt"
        source_path   = "testdata/readme.txt"
        source_sha256 = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
      }
    }
  }
  expect_failures = [hubspot_file.this["readme"]]
}

run "rejects_duplicate_file_names_in_one_destination" {
  command = plan
  variables {
    folders = { assets = { name = "Assets" } }
    files = {
      first = {
        name          = "readme.txt"
        source_path   = "testdata/readme.txt"
        source_sha256 = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
        folder_key    = "assets"
      }
      second = {
        name          = "readme.txt"
        source_path   = "testdata/readme.txt"
        source_sha256 = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
        folder_key    = "assets"
      }
    }
  }
  expect_failures = [var.files]
}
