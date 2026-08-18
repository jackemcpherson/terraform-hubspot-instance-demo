# Manages one explicit level of HubSpot Files configuration through stable local keys.
resource "hubspot_file_folder" "this" {
  for_each = var.folders

  name             = each.value.name
  parent_folder_id = var.parent_folder_id
}

resource "hubspot_file" "this" {
  for_each = toset(nonsensitive(keys(var.files)))

  name          = var.files[each.key].name
  folder_id     = var.files[each.key].folder_key == null ? var.parent_folder_id : try(hubspot_file_folder.this[var.files[each.key].folder_key].id, null)
  source_path   = var.files[each.key].source_path
  source_sha256 = var.files[each.key].source_sha256
  access        = var.files[each.key].access

  lifecycle {
    precondition {
      condition = (
        var.files[each.key].folder_key == null
        ? var.parent_folder_id != null
        : contains(keys(var.folders), var.files[each.key].folder_key)
      )
      error_message = "Every file must select a folder key managed by this module instance or an explicit parent_folder_id."
    }
  }
}
