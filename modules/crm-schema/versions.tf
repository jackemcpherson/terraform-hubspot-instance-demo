terraform {
  required_version = ">= 1.8, < 2.0"

  required_providers {
    hubspot = {
      source  = "registry.opentofu.org/jackemcpherson/hubspot"
      version = "= 0.1.0-alpha.1"
    }
  }
}
