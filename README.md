# Northstar HubSpot CRM Demo

This repository is a realistic consumer of
`jackemcpherson/hubspot` `v0.2.0`. It manages the CRM property schema for
Northstar Cloud, a fictional B2B software company, in a disposable HubSpot Free
portal.

The desired state contains four property groups and ten non-sensitive
properties across contacts, companies, deals, and tickets. Ten is a deliberate
fixture size, not provider admission control or a claimed API-created-property
limit. Remote create responses remain authoritative.
The provider does not manage CRM records, so sample contacts, companies, and
deals are outside this repository's ownership.

---

## Managed Model

| CRM object | Property group               | Examples                                           |
| ---------- | ---------------------------- | -------------------------------------------------- |
| Contacts   | Northstar customer context   | Buyer role, onboarding status, success review date |
| Companies  | Northstar account profile    | Account tier, renewal date                         |
| Deals      | Northstar commercial context | Commercial motion, implementation risk             |
| Tickets    | Northstar support context    | Support priority, support summary, response due at |

All owned identifiers start with `ns_`. Enumeration map keys are durable CRM
values. Labels can change without a key change.

## Rehearse Against the Local Provider

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

`make apply` consumes the exact plan created by `make plan`. It does not create
a replacement plan.
Open the HubSpot property settings after apply and filter for `ns_` to show the
managed groups and fields.

The provider requirement omits a registry hostname. OpenTofu resolves
`registry.opentofu.org/jackemcpherson/hubspot`. Terraform resolves
`registry.terraform.io/jackemcpherson/hubspot`. The local workflow maps both
identities to the same new binary. The `make check` command checks that binary
with both engines. To run Terraform explicitly:

```sh
ENGINE=terraform ./scripts/demo local plan
ENGINE=terraform ./scripts/demo local apply
```

## Demo Sequence

1. Open `schemas.tf` to show the model and reusable module.
2. Run `make plan` to propose four groups and ten properties.
3. Run `make apply` to create the planned schema.
4. Open the HubSpot property settings and filter for `ns_`.
5. Change one property label in the HubSpot interface.
6. Run `make plan` again to show the authored drift repair.
7. Apply the reviewed repair plan.
8. Run `make output` to show the standard CRM object types.

Cleanup is also review-first:

```sh
make destroy-plan
make destroy-apply
```

HubSpot can block property-group deletion while properties remain active. The
provider orders property deletion before group cleanup through the module's
resource references.

## Published Release

After `v0.2.0` is available from the registry, use the exact committed
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

### Release Checklist

1. Publish provider `v0.2.0` and confirm both public registries list it.
2. Run `make registry-init` and `ENGINE=terraform make registry-init`, then
   review each selected provider source and checksum set.
3. Commit both registry-generated files under `locks/` before applying.

Git ignores local state for this disposable demo portal. A shared environment
should use a remote, encrypted, locked backend with one CI writer.

Release automation can reconstruct local state with `scripts/demo local adopt`.
It uses the ten known properties and four known groups. The command requires an
empty plan before a reviewed teardown. Unmanaged or drifted configuration stops
the process.
