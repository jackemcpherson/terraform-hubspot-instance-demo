variable "parent_folder_id" {
  type        = string
  description = "Generated ID of the parent File folder; null manages one level at File Manager root."
  default     = null
  nullable    = true

  validation {
    condition     = var.parent_folder_id == null || can(regex("^[1-9][0-9]*$", var.parent_folder_id))
    error_message = "parent_folder_id must be null or a non-zero decimal generated folder ID."
  }
}

variable "folders" {
  type = map(object({
    name = string
  }))
  description = "Direct child File folders keyed by stable local identity."
  default     = {}
  nullable    = false

  validation {
    condition     = alltrue([for key in keys(var.folders) : can(regex("^[a-z][a-z0-9_]*$", key))])
    error_message = "Folder keys must be stable lowercase local identifiers."
  }

  validation {
    condition = alltrue([
      for folder in values(var.folders) :
      trimspace(folder.name) != "" &&
      trimspace(folder.name) == folder.name &&
      !contains([".", ".."], folder.name) &&
      !strcontains(folder.name, "/") &&
      !strcontains(folder.name, "\\")
    ])
    error_message = "Every folder name must be nonblank, have no surrounding whitespace, not be . or .., and contain no slash or backslash."
  }

  validation {
    condition     = length(distinct([for folder in values(var.folders) : folder.name])) == length(var.folders)
    error_message = "Folder names must be unique within the module's direct parent."
  }
}

variable "files" {
  type = map(object({
    name          = string
    source_path   = string
    source_sha256 = string
    folder_key    = optional(string)
    access        = optional(string, "PRIVATE")
  }))
  description = "Managed files keyed by stable local identity."
  default     = {}
  nullable    = false
  sensitive   = true

  validation {
    condition     = alltrue([for key in keys(var.files) : can(regex("^[a-z][a-z0-9_]*$", key))])
    error_message = "File keys must be stable lowercase local identifiers."
  }

  validation {
    condition = alltrue([
      for file in values(var.files) :
      trimspace(file.name) != "" &&
      trimspace(file.name) == file.name &&
      !contains([".", ".."], file.name) &&
      !strcontains(file.name, "/") &&
      !strcontains(file.name, "\\")
    ])
    error_message = "Every file name must be nonblank, have no surrounding whitespace, not be . or .., and contain no slash or backslash."
  }

  validation {
    condition = alltrue([
      for file in values(var.files) :
      !can(regex("(?i)\\.(sh|bat|com|elf|bin|exe|jar|rpm|deb)$", file.name))
    ])
    error_message = "Managed file names must not use the blocked sh, bat, com, elf, bin, exe, jar, rpm, or deb extension."
  }

  validation {
    condition     = alltrue([for file in values(var.files) : trimspace(file.source_path) != ""])
    error_message = "Every source_path must identify a local source file."
  }

  validation {
    condition     = alltrue([for file in values(var.files) : can(regex("^[0-9a-f]{64}$", file.source_sha256))])
    error_message = "Every source_sha256 must be exactly 64 lowercase hexadecimal characters."
  }

  validation {
    condition     = alltrue([for file in values(var.files) : contains(["PRIVATE", "PUBLIC_INDEXABLE", "PUBLIC_NOT_INDEXABLE"], file.access)])
    error_message = "Every file access must be PRIVATE, PUBLIC_INDEXABLE, or PUBLIC_NOT_INDEXABLE."
  }

  validation {
    condition = alltrue([
      for file in values(var.files) :
      file.folder_key == null || can(regex("^[a-z][a-z0-9_]*$", file.folder_key))
    ])
    error_message = "Every folder_key must be null or a stable lowercase local folder identifier."
  }

  validation {
    condition = length(distinct([
      for file in values(var.files) : "${coalesce(file.folder_key, "__parent__")}\u0000${file.name}"
    ])) == length(var.files)
    error_message = "File names must be unique within each resolved destination folder."
  }
}
