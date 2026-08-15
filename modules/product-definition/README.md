# Product Definition Module

Manages standard HubSpot Product definitions with `for_each` over stable local
keys. HubSpot-generated numeric IDs remain the remote and import identities.

```hcl
module "products" {
  source = "./modules/product-definition"

  products = {
    support = {
      name                     = "Annual support"
      sku                      = "support-annual"
      description              = "Priority annual support"
      price                    = "1200.00"
      cost                     = "300.00"
      recurring_billing_period = "P12M"
    }
  }
}
```

Null optional values remain unmanaged. Empty optional values clear the remote
property. OpenTofu is the primary engine. Terraform uses the same provider
protocol.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8, < 2.0 |
| <a name="requirement_hubspot"></a> [hubspot](#requirement\_hubspot) | >= 0.7.0, < 0.8.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hubspot"></a> [hubspot](#provider\_hubspot) | >= 0.7.0, < 0.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [hubspot_product.this](https://registry.terraform.io/providers/jackemcpherson/hubspot/latest/docs/resources/product) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_products"></a> [products](#input\_products) | Standard HubSpot Product definitions keyed by stable local identity. | <pre>map(object({<br/>    name                     = string<br/>    sku                      = string<br/>    description              = string<br/>    price                    = string<br/>    cost                     = optional(string)<br/>    recurring_billing_period = optional(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ids"></a> [ids](#output\_ids) | Generated HubSpot Product IDs keyed by stable local identity. |
<!-- END_TF_DOCS -->
