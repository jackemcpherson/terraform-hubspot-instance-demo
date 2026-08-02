terraform {
  required_version = ">= 1.8, < 2.0"

  required_providers {
    hubspot = {
      source  = "jackemcpherson/hubspot"
      version = ">= 0.2.0, < 0.3.0"
    }
  }
}
