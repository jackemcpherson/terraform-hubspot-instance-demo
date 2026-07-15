module "crm_schema" {
  for_each = local.schemas
  source   = "./modules/crm-schema"

  object_type = each.key
  group       = each.value.group
  properties  = each.value.properties
}

data "hubspot_property_definition" "builtin_email" {
  object_type = "contacts"
  name        = "email"
}

data "hubspot_property_definitions" "observed" {
  for_each = local.schemas

  object_type = each.key
  depends_on  = [module.crm_schema]
}
