output "folder_ids" {
  description = "Generated HubSpot folder IDs keyed by stable local folder identity."
  value       = { for key, folder in hubspot_file_folder.this : key => folder.id }
}

output "file_ids" {
  description = "Generated HubSpot file IDs keyed by stable local file identity."
  value       = { for key, file in hubspot_file.this : key => file.id }
}

output "files" {
  description = "Bounded Managed file observations keyed by stable local file identity."
  value = {
    for key, file in hubspot_file.this : key => {
      path                = file.path
      file_md5            = file.file_md5
      size                = file.size
      url                 = file.url
      default_hosting_url = file.default_hosting_url
    }
  }
}
