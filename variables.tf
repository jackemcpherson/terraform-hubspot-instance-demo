variable "northstar_files_prefix" {
  description = "Run-scoped prefix for cumulative Northstar Files configuration."
  type        = string
  default     = "ns_"

  validation {
    condition = (
      startswith(var.northstar_files_prefix, "ns_") &&
      endswith(var.northstar_files_prefix, "_") &&
      (var.northstar_files_prefix == "ns_" || length(var.northstar_files_prefix) <= 14) &&
      length(regexall("[^0-9A-Za-z_]", var.northstar_files_prefix)) == 0
    )
    error_message = "northstar_files_prefix must be ns_ or a run prefix of at most 14 letters, digits, and underscores that starts with ns_ and ends with _."
  }
}

variable "northstar_membership_email" {
  description = "Caller-supplied email for the disposable Northstar account membership."
  type        = string
  sensitive   = true

  validation {
    condition = (
      var.northstar_membership_email == lower(trimspace(var.northstar_membership_email)) &&
      can(regex("^[^[:space:]@]+@[^[:space:]@]+$", var.northstar_membership_email))
    )
    error_message = "northstar_membership_email must be a lowercase address without surrounding whitespace."
  }
}

locals {
  northstar_files_names = var.northstar_files_prefix == "ns_" ? {
    brand        = "ns_brand"
    downloads    = "ns_downloads"
    private_file = "ns_private_readme.txt"
    public_file  = "ns_public_logo.svg"
    } : {
    brand        = "${var.northstar_files_prefix}b"
    downloads    = "${var.northstar_files_prefix}d"
    private_file = "${var.northstar_files_prefix}p.txt"
    public_file  = "${var.northstar_files_prefix}l.svg"
  }
}
