# Files configuration module

Creates one explicit hierarchy level of HubSpot Files configuration. Stable map
keys own generated IDs; names, paths, delivery URLs, and hashes do not identify
ownership. The module requires the exact `files` scope and supports OpenTofu and
Terraform `>= 1.8, < 2.0` with HubSpot provider `>= 0.4.0, < 0.5.0`.

Compose deeper hierarchy by passing a generated `folder_ids` value to another
module instance:

```hcl
module "files_root" {
  source  = "./modules/files-configuration"
  folders = { brand = { name = "Brand" } }
}

module "files_brand" {
  source           = "./modules/files-configuration"
  parent_folder_id = module.files_root.folder_ids["brand"]
  folders          = { downloads = { name = "Downloads" } }
}
```

Files select a direct child with `folder_key`, or omit it to target a non-null
explicit parent. Generated ID references create file-first and leaf-first
teardown edges. Folder deletion still refuses any active owned or unowned child.

The source path is sensitive and its lowercase SHA-256 binds the reviewed bytes.
The provider rechecks regular-file bytes and the 20,000,000-byte Free limit at
plan and apply. The module intentionally exposes no raw upload options, implicit
paths, URL import, overwrite, TTL, hidden or sensitive access, signed URL,
cascade deletion, GDPR purge, MIME override, charset override, or API route.

Changing a folder or file key without a state move deletes the old generated
identity and creates another. For a pure key rename, add an explicit caller-side
move before applying:

```hcl
moved {
  from = module.files_root.hubspot_file_folder.this["brand"]
  to   = module.files_root.hubspot_file_folder.this["brand_assets"]
}
```

Create and update collisions fail instead of adopting by mutable name or path.
If a failed create diagnostic reports a generated ID, inspect that exact asset;
import only the confirmed generated ID when it is the intended asset, or remove
the residual before retrying. If no ID was returned, inspect only the exact
intended parent or folder. Never search for or adopt recovery state by name,
path, or URL.

Normal destroy removes Managed files before referenced File folders and folders
leaf-first. HubSpot may retain deleted assets in Trash after active absence.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8, < 2.0 |
| <a name="requirement_hubspot"></a> [hubspot](#requirement\_hubspot) | >= 0.4.0, < 0.7.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hubspot"></a> [hubspot](#provider\_hubspot) | >= 0.4.0, < 0.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [hubspot_file.this](https://registry.terraform.io/providers/jackemcpherson/hubspot/latest/docs/resources/file) | resource |
| [hubspot_file_folder.this](https://registry.terraform.io/providers/jackemcpherson/hubspot/latest/docs/resources/file_folder) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_files"></a> [files](#input\_files) | Managed files keyed by stable local identity. | <pre>map(object({<br/>    name          = string<br/>    source_path   = string<br/>    source_sha256 = string<br/>    folder_key    = optional(string)<br/>    access        = optional(string, "PRIVATE")<br/>  }))</pre> | `{}` | no |
| <a name="input_folders"></a> [folders](#input\_folders) | Direct child File folders keyed by stable local identity. | <pre>map(object({<br/>    name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_parent_folder_id"></a> [parent\_folder\_id](#input\_parent\_folder\_id) | Generated ID of the parent File folder; null manages one level at File Manager root. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_file_ids"></a> [file\_ids](#output\_file\_ids) | Generated HubSpot file IDs keyed by stable local file identity. |
| <a name="output_files"></a> [files](#output\_files) | Bounded Managed file observations keyed by stable local file identity. |
| <a name="output_folder_ids"></a> [folder\_ids](#output\_folder\_ids) | Generated HubSpot folder IDs keyed by stable local folder identity. |
<!-- END_TF_DOCS -->
