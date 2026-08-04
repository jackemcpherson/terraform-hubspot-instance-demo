# Northstar HubSpot CRM Demo

This repository is a realistic consumer of
`jackemcpherson/hubspot` `v0.4.0`. Its cumulative root manages the CRM property
schema and one stable-keyed contact Form definition for Northstar Cloud, a
fictional B2B software company, in a disposable HubSpot Free portal. The local
`files-configuration` module and executable composition example prepare the
Files configuration slice without claiming that the cumulative live journey has
run before its protected qualification step.

The desired state contains four property groups, ten non-sensitive properties
across contacts, companies, deals, and tickets, and one `ns_contact_us` form.
Ten properties is a deliberate
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
values. The form's `contact_us` map key is its durable local address, while the
module output exposes its generated HubSpot ID for exact import and verification.
Labels and remote names can change without a key change.

The Files example under `examples/files-configuration` composes two hierarchy
levels through generated `folder_ids`, with one private file and one public
non-indexable file. Source paths are sensitive, reviewed SHA-256 values bind the
bytes, and ordinary references produce file-first and leaf-first teardown edges.

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
Open the HubSpot property and Forms settings after apply and filter for `ns_` to
show the cumulative managed configuration.

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
2. Run `make plan` to propose four groups, ten properties, and one contact form.
3. Run `make apply` to create the planned cumulative configuration.
4. Open the HubSpot property and Forms settings and filter for `ns_`.
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
resource references. Form teardown archives the exact generated identity; it is
retained as an Archived tombstone rather than purged or restored. The Files
composition example removes Managed files before referenced folders and folders
leaf-first; normal deletion proves active absence but leaves HubSpot-managed
Trash retention in place.

## Published Release

After `v0.4.0` is available from both registries, use the exact committed
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

1. Publish provider `v0.4.0` and confirm both public registries list it.
2. Run `make registry-init` and `ENGINE=terraform make registry-init`, then
   review each selected provider source and checksum set.
3. Commit both registry-generated files under `locks/` before applying.

Git ignores local state for this disposable demo portal. A shared environment
should use a remote, encrypted, locked backend with one CI writer.

Release automation can reconstruct local state with `scripts/demo local adopt`.
It uses the ten known properties and four known groups, and imports the Form by
the generated ID from current state output. When no state output exists, set the
protected `HUBSPOT_NORTHSTAR_FORM_ID`; the script never discovers a Form by its
remote name. The command requires an empty plan before a reviewed teardown.
Unmanaged or drifted configuration stops the process.
