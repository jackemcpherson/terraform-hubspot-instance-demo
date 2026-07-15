# Northstar HubSpot CRM demo

This repository is a realistic consumer of
`jackemcpherson/hubspot` `v0.1.0-alpha.1`. It manages the CRM schema for
Northstar Cloud, a fictional B2B software company, in a disposable HubSpot Free
portal.

The desired state contains three property groups and ten ordinary
non-sensitive properties across contacts, companies, and deals. It deliberately
uses only the provider's Free-alpha surface and fits HubSpot's current
[Free limit of ten custom properties in total](https://legal.hubspot.com/hubspot-product-and-services-catalog).
The provider does not manage CRM records, so sample contacts, companies, and
deals are outside this repository's ownership.

## Managed model

| CRM object | Property group | Examples |
|---|---|---|
| Contacts | Northstar customer context | Buyer role, product interest, onboarding status, success review date |
| Companies | Northstar account profile | Account tier, industry vertical, renewal date |
| Deals | Northstar commercial context | Commercial motion, product line, implementation risk |

All owned identifiers start with `ns_`. Enumeration map keys are durable CRM
values; labels may change without renaming those keys.

## Rehearse against the local provider

The default workflow builds the provider from the sibling
`../terraform-provider-hubspot` repository. It writes the development override,
plans, and state only under ignored local paths. No credential enters HCL or
Terraform/OpenTofu state.

Authenticate the HubSpot CLI account once, or export a static app token:

```sh
hs account auth
export HUBSPOT_CLI_ACCOUNT=jack
# Alternative: export HUBSPOT_ACCESS_TOKEN='...'
```

Then run:

```sh
make check
make plan
make apply
make output
```

`make apply` consumes the exact plan created by `make plan`; it does not re-plan.
Open the HubSpot property settings after apply and filter for `ns_` to show the
managed groups and fields.

To use Terraform instead of OpenTofu:

```sh
ENGINE=terraform ./scripts/demo local plan
ENGINE=terraform ./scripts/demo local apply
```

## Demo sequence

1. Show `schemas.tf`: one coherent model rendered through a reusable module.
2. Run `make plan`: three groups and ten properties are proposed.
3. Run `make apply`, then show the `ns_` fields in HubSpot.
4. Change one property label in the HubSpot UI.
5. Run `make plan` again: the provider reports the authored drift repair.
6. Apply that reviewed plan and run `make output` to show collection and singular
   data-source readback.

Cleanup is also review-first:

```sh
make destroy-plan
make destroy-apply
```

HubSpot can block property-group deletion while properties remain active. The
provider orders property deletion before group cleanup through the module's
resource references.

## Published alpha

After `v0.1.0-alpha.1` is available from the registry, use the exact committed
pin rather than the local development override:

```sh
make registry-init
# Commit the generated .terraform.lock.hcl before proceeding.
make registry-plan
make registry-apply
make registry-output
make registry-destroy-plan
make registry-destroy-apply
```

Publication checklist:

1. Create the GitHub repository for `terraform-provider-hubspot` and push the
   `release/free-alpha` branch.
2. Create the GitHub repository for this demo and push `main`.
3. Publish `v0.1.0-alpha.1`, then run `make registry-init` here and commit the
   registry-generated `.terraform.lock.hcl`.

Local state is intentional for this disposable demo portal and is ignored by
Git. A real shared environment should use a remote, encrypted, locked backend
with a single CI writer.
