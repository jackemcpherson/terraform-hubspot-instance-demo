variable "northstar_files_prefix" {
  description = "Run-scoped prefix for cumulative Northstar Files configuration."
  type        = string
  default     = "ns_"

  validation {
    condition = (
      startswith(var.northstar_files_prefix, "ns_") &&
      endswith(var.northstar_files_prefix, "_") &&
      length(var.northstar_files_prefix) <= 100 &&
      length(regexall("[^0-9A-Za-z_]", var.northstar_files_prefix)) == 0
    )
    error_message = "northstar_files_prefix must start with ns_, end with _, contain only letters, digits, and underscores, and be at most 100 characters."
  }
}
