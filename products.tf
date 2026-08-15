module "product_definitions" {
  source = "./modules/product-definition"

  products = {
    northstar_support = {
      name                     = "Northstar annual support"
      sku                      = "ns_support_annual"
      description              = "Priority support for Northstar customers"
      price                    = "1200.00"
      cost                     = "300.00"
      recurring_billing_period = "P12M"
    }
  }
}
