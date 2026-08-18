# Northstar HubSpot CRM Demo

This repository is a realistic consumer of
`jackemcpherson/hubspot` `v0.7.0`. Its cumulative root manages the CRM property
schema, one stable-keyed contact Form definition, two explicit File folder
levels, two stable-keyed Managed files, one guarded account membership, and its
separate CRM user profile, and one standard Product definition for Northstar
Cloud, a fictional B2B software company, in a disposable HubSpot Free portal.

The desired state contains four property groups, ten non-sensitive properties
across contacts, companies, deals, and tickets, one `ns_contact_us` form, and
private plus public non-indexable tiny inert files under explicit generated
folder IDs, one caller-supplied account membership with welcome email disabled,
and selected CRM profile properties joined through that membership's canonical
Settings ID, plus one `ns_support_annual` Product with an exact decimal price,
cost, and annual recurrence.
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

The `northstar_operator` membership key is also durable local identity. Its
email is supplied through `HUBSPOT_NORTHSTAR_MEMBERSHIP_EMAIL`; the repository
does not embed a portal identity. The module exposes the canonical Settings user
ID, requires an explicit welcome-email choice, and opts into removal only
because this root targets a disposable portal.

The `northstar_operator` profile key is the same stable local identity, but the
profile remains a separate resource. It manages job title, availability,
timezone, and weekday working hours. Null profile properties remain unmanaged.
The profile module stores the account-specific CRM user ID and depends on the
membership module's Settings ID through an ordinary reference.

The `annual_support` Product key is durable local identity. HubSpot's generated
numeric ID is the remote and import identity; SKU and name are managed values,
never lookup keys. Null cost or recurrence remains unmanaged and empty string
clears it. Equivalent remote decimal spelling does not trigger a write.

The cumulative root and Files example under `examples/files-configuration`
compose two hierarchy levels through generated `folder_ids`, with one private
file and one public non-indexable file. Source paths are sensitive, reviewed
SHA-256 values bind the bytes, and ordinary references produce file-first and
leaf-first teardown edges.

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

Every live lifecycle command also requires the exact disposable membership
address:

```sh
export HUBSPOT_NORTHSTAR_MEMBERSHIP_EMAIL='owned-fixture@example.com'
```

Never use a production user. The token needs Settings user read/write access for
membership plus the exact `crm.objects.users.read` and
`crm.objects.users.write` pair for the CRM profile, in addition to the
cumulative CRM schema, Forms, and Files scopes. Product management needs exactly
`crm.objects.products.read` and `crm.objects.products.write`, not the legacy
`e-commerce` scope.

Then run:

```sh
make check
make plan
make apply
make output
```

`make apply` consumes the exact plan created by `make plan`. It does not create
a replacement plan.
Open HubSpot property, Forms, File Manager, and Products settings after apply
and filter for `ns_` to show cumulative managed configuration.

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
2. Run `make plan` to propose four groups, ten properties, one contact form, two
   folders, two Managed files, one account membership, its CRM profile, and one
   Product definition.
3. Run `make apply` to create the planned cumulative configuration.
4. Open HubSpot property, Forms, File Manager, and Products settings and filter
   for `ns_`.
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
retained as an Archived tombstone rather than purged or restored. Files teardown
removes Managed files before referenced folders and folders leaf-first; normal
deletion proves active absence but leaves HubSpot-managed Trash retention in
place. Membership teardown requires the local removal opt-in, rereads the exact
Settings ID and email, refuses a Super Admin, and proves both identities absent.
Remove the resource from state instead when the portal membership must remain.
CRM profile teardown happens first, performs no remote write, and leaves the
managed profile values as a documented non-destructive residual. Terminal
verification proves the membership is absent while the exact CRM profile and
retained values remain.
Product teardown archives its exact generated ID, proves active absence, and
verifies the same archived identity. HubSpot may retain the tombstone for 90
days; the provider does not restore or purge it.

## Published Release

After `v0.7.0` is available from both registries, regenerate both committed
registry locks and use the exact committed pin rather than the local development
override:

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

1. Publish provider `v0.7.0` and confirm both public registries list it.
2. Run `make registry-init` and `ENGINE=terraform make registry-init`, then
   review each selected provider source and checksum set.
3. Commit both registry-generated files under `locks/` before applying.

Git ignores local state for this disposable demo portal. A shared environment
should use a remote, encrypted, locked backend with one CI writer.

Release automation can reconstruct local state with `scripts/demo local adopt`.
It uses the ten known properties and four known groups, imports the Form, File
folders, and Managed files by generated IDs from stable module outputs, and
imports the membership through the explicit `email:` form before storing its
canonical Settings ID, then imports the profile through the explicit
`membership:` form before storing its canonical CRM ID, and imports the Product
only by its exact generated ID. When no state output exists for the other generated
identities, supply `HUBSPOT_NORTHSTAR_FORM_ID`,
`HUBSPOT_NORTHSTAR_BRAND_FOLDER_ID`, `HUBSPOT_NORTHSTAR_DOWNLOADS_FOLDER_ID`,
`HUBSPOT_NORTHSTAR_PRIVATE_FILE_ID`, and `HUBSPOT_NORTHSTAR_PUBLIC_FILE_ID` from
the protected handoff. Supply `HUBSPOT_NORTHSTAR_PRODUCT_ID` for Product
adoption when state output is unavailable. The script never discovers
configuration by name, SKU, path, URL, or search. The command requires an empty
plan before reviewed teardown.
Unmanaged or drifted configuration stops the process.
