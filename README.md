# Northstar HubSpot CRM demo

This repository is a realistic consumer of
`jackemcpherson/hubspot` `v0.1.0`. It manages the CRM schema for
Northstar Cloud, a fictional B2B software company, in a disposable HubSpot Free
portal.

The desired state contains four property groups and ten ordinary
non-sensitive properties across contacts, companies, deals, and tickets. It deliberately
uses only the provider's Free-tier surface and fits HubSpot's current
[Free limit of ten custom properties in total](https://legal.hubspot.com/hubspot-product-and-services-catalog).
The provider does not manage CRM records, so sample contacts, companies, and
deals are outside this repository's ownership.

## Managed model

| CRM object | Property group | Examples |
|---|---|---|
| Contacts | Northstar customer context | Buyer role, onboarding status, success review date |
| Companies | Northstar account profile | Account tier, renewal date |
| Deals | Northstar commercial context | Commercial motion, implementation risk |
| Tickets | Northstar support context | Support priority, support summary, response due at |

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

The provider requirement deliberately omits a registry hostname: OpenTofu resolves
`registry.opentofu.org/jackemcpherson/hubspot`, while Terraform resolves
`registry.terraform.io/jackemcpherson/hubspot`. The local workflow maps both
identities to the same freshly built binary, so `make check` rehearses the exact
candidate surface under both engines. To run Terraform explicitly:

```sh
ENGINE=terraform ./scripts/demo local plan
ENGINE=terraform ./scripts/demo local apply
```

## Demo sequence

1. Show `schemas.tf`: one coherent model rendered through a reusable module.
2. Run `make plan`: four groups and ten properties are proposed.
3. Run `make apply`, then show the `ns_` fields in HubSpot.
4. Change one property label in the HubSpot UI.
5. Run `make plan` again: the provider reports the authored drift repair.
6. Apply that reviewed plan and run `make output` to show collection readback for
   every standard CRM object type and singular built-in-property discovery.

Cleanup is also review-first:

```sh
make destroy-plan
make destroy-apply
```

HubSpot can block property-group deletion while properties remain active. The
provider orders property deletion before group cleanup through the module's
resource references.

## Published release

After `v0.1.0` is available from the registry, use the exact committed
pin rather than the local development override:

```sh
make registry-init
# Generate the independent Terraform Registry lock decision.
ENGINE=terraform make registry-init
# Review and commit locks/tofu/.terraform.lock.hcl and
# locks/terraform/.terraform.lock.hcl before proceeding.
make registry-plan
make registry-apply
make registry-verify
make registry-output
make registry-destroy-plan
make registry-destroy-apply
```

After the OpenTofu destroy completes, repeat the full registry lifecycle with
Terraform against the now-empty state:

```sh
ENGINE=terraform make registry-plan
ENGINE=terraform make registry-apply
ENGINE=terraform make registry-verify
ENGINE=terraform make registry-output
ENGINE=terraform make registry-destroy-plan
ENGINE=terraform make registry-destroy-apply
```

Public-release checklist:

1. Publish provider `v0.1.0` and confirm both public registries list it.
2. Run `make registry-init` and `ENGINE=terraform make registry-init`, then
   review each selected provider source and checksum set.
3. Commit both registry-generated files under `locks/` before applying.

Local state is intentional for this disposable demo portal and is ignored by
Git. A real shared environment should use a remote, encrypted, locked backend
with a single CI writer.
