mock_provider "hubspot" {
  mock_resource "hubspot_file_folder" {
    defaults = {
      id = "10001"
    }
  }

  mock_resource "hubspot_account_membership" {
    defaults = {
      id = "30001"
    }
  }
}

run "tolerates_archived_product_during_refresh" {
  command = plan

  override_module {
    target = module.product_definitions

    outputs = {
      ids = {}
    }
  }

  variables {
    northstar_membership_email = "northstar-operator@example.com"
  }

  assert {
    condition     = output.northstar_support_product_id == null
    error_message = "The single Product output must tolerate temporary absence during refresh-only reconciliation."
  }
}
