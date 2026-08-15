# Manages standard Product definitions through stable local keys.
resource "hubspot_product" "this" {
  for_each = var.products

  name                     = each.value.name
  sku                      = each.value.sku
  description              = each.value.description
  price                    = each.value.price
  cost                     = each.value.cost
  recurring_billing_period = each.value.recurring_billing_period
}
