variable "products" {
  type = map(object({
    name                     = string
    sku                      = string
    description              = string
    price                    = string
    cost                     = optional(string)
    recurring_billing_period = optional(string)
  }))
  description = "Standard HubSpot Product definitions keyed by stable local identity."
  nullable    = false

  validation {
    condition     = alltrue([for key in keys(var.products) : can(regex("^[a-z][a-z0-9_]*$", key))])
    error_message = "Product keys must be stable lowercase local identifiers."
  }

  validation {
    condition = alltrue(flatten([
      for product in values(var.products) : [
        product.name != "" && trimspace(product.name) == product.name,
        product.sku != "" && trimspace(product.sku) == product.sku,
        product.description != "" && trimspace(product.description) == product.description,
      ]
    ]))
    error_message = "Product names, SKUs, and descriptions must be nonblank without surrounding whitespace."
  }

  validation {
    condition     = length(distinct([for product in values(var.products) : product.sku])) == length(var.products)
    error_message = "Product SKUs must be unique within one module instance."
  }

  validation {
    condition = alltrue([
      for product in values(var.products) : can(regex("^(0|[1-9][0-9]*)(\\.[0-9]+)?$", product.price))
    ])
    error_message = "Every Product price must be a canonical non-negative decimal string."
  }

  validation {
    condition = alltrue([
      for product in values(var.products) : product.cost == null ? true : (
        product.cost == "" || can(regex("^(0|[1-9][0-9]*)(\\.[0-9]+)?$", product.cost))
      )
    ])
    error_message = "Each Product cost must be null, empty, or a canonical non-negative decimal string."
  }

  validation {
    condition = alltrue([
      for product in values(var.products) : product.recurring_billing_period == null ? true : (
        product.recurring_billing_period == "" || can(regex("^P[1-9][0-9]*M$", product.recurring_billing_period))
      )
    ])
    error_message = "Each recurring billing period must be null, empty, or P#M with a positive month count."
  }
}
