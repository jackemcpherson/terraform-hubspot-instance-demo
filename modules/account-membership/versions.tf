terraform {
  required_version = ">= 1.8, < 2.0"

  required_providers {
    hubspot = {
      source  = "jackemcpherson/hubspot"
      version = ">= 0.5.0, < 0.6.0"
    }
  }
}
