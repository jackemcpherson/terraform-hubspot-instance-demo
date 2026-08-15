mock_provider "hubspot" {
  mock_resource "hubspot_product" {
    defaults = {
      id = "70001"
    }
  }
}

run "applies_stable_keyed_products" {
  command = apply

  variables {
    products = {
      support = {
        name                     = "Northstar support"
        sku                      = "ns_support"
        description              = "Annual support"
        price                    = "1200.00"
        cost                     = "300.00"
        recurring_billing_period = "P12M"
      }
    }
  }

  assert {
    condition     = output.ids == { support = "70001" }
    error_message = "The module must expose generated Product IDs through stable keys."
  }

  assert {
    condition = (
      hubspot_product.this["support"].sku == "ns_support" &&
      hubspot_product.this["support"].price == "1200.00"
    )
    error_message = "The module must pass exact Product values to the resource."
  }
}

run "rejects_duplicate_skus" {
  command = plan

  variables {
    products = {
      first = {
        name        = "First"
        sku         = "duplicate"
        description = "First Product"
        price       = "1"
      }
      second = {
        name        = "Second"
        sku         = "duplicate"
        description = "Second Product"
        price       = "2"
      }
    }
  }

  expect_failures = [var.products]
}
