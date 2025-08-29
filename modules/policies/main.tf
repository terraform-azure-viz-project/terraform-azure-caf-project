locals {
  prefix = "pol"
  init_prefix = "init"
  app    = "hipaa"
  env    = var.environment
  loc    = var.location_short
  instance_count = "001"
  full_policy_files = fileset("${path.module}/json_policies/full", "*.json")
  sandbox_policy_files = fileset("${path.module}/json_policies/sandbox", "*.json")
}

resource "azurerm_policy_definition" "full_custom_policies" {
  for_each = local.full_policy_files

  name                = "${local.prefix}-${local.app}-full-${replace(basename(each.value), ".json", "")}-${local.env}-${local.loc}-${local.instance_count}"
  display_name        = "${local.prefix}-${local.app}-full-${replace(basename(each.value), ".json", "")}-${local.env}-${local.loc}-${local.instance_count}"
  policy_type         = jsondecode(file("${path.module}/json_policies/full/${each.value}")).properties.policyType
  mode                = jsondecode(file("${path.module}/json_policies/full/${each.value}")).properties.mode
  description         = jsondecode(file("${path.module}/json_policies/full/${each.value}")).properties.description
  metadata            = jsondecode(file("${path.module}/json_policies/full/${each.value}")).properties.metadata
  parameters          = try(jsondecode(file("${path.module}/json_policies/full/${each.value}")).properties.parameters, {})
  policy_rule         = jsondecode(file("${path.module}/json_policies/full/${each.value}")).properties.policyRule
  management_group_id = var.platform_mg_id
}

resource "azurerm_policy_definition" "sandbox_custom_policies" {
  for_each = local.sandbox_policy_files

  name                = "${local.prefix}-${local.app}-sandbox-${replace(basename(each.value), ".json", "")}-${local.env}-${local.loc}-${local.instance_count}"
  display_name        = "${local.prefix}-${local.app}-sandbox-${replace(basename(each.value), ".json", "")}-${local.env}-${local.loc}-${local.instance_count}"
  policy_type         = jsondecode(file("${path.module}/json_policies/sandbox/${each.value}")).properties.policyType
  mode                = jsondecode(file("${path.module}/json_policies/sandbox/${each.value}")).properties.mode
  description         = jsondecode(file("${path.module}/json_policies/sandbox/${each.value}")).properties.description
  metadata            = jsondecode(file("${path.module}/json_policies/sandbox/${each.value}")).properties.metadata
  parameters          = try(jsondecode(file("${path.module}/json_policies/sandbox/${each.value}")).properties.parameters, {})
  policy_rule         = jsondecode(file("${path.module}/json_policies/sandbox/${each.value}")).properties.policyRule
  management_group_id = var.sandbox_mg_id
}

resource "azurerm_policy_set_definition" "hipaa_full_initiative" {
  name                = "${local.init_prefix}-${local.app}-full-${local.env}-${local.loc}-${local.instance_count}"
  policy_type         = "Custom"
  display_name        = "${local.init_prefix}-${local.app}-full-${local.env}-${local.loc}-${local.instance_count}"
  management_group_id = var.platform_mg_id

  dynamic "policy_definition_reference" {
    for_each = azurerm_policy_definition.full_custom_policies
    content {
      policy_definition_id = policy_definition_reference.value.id
      reference_id         = policy_definition_reference.key
    }
  }
}

resource "azurerm_policy_set_definition" "hipaa_sandbox_initiative" {
  name                = "${local.init_prefix}-${local.app}-sandbox-${local.env}-${local.loc}-${local.instance_count}"
  policy_type         = "Custom"
  display_name        = "${local.init_prefix}-${local.app}-sandbox-${local.env}-${local.loc}-${local.instance_count}"
  management_group_id = var.sandbox_mg_id

  dynamic "policy_definition_reference" {
    for_each = azurerm_policy_definition.sandbox_custom_policies
    content {
      policy_definition_id = policy_definition_reference.value.id
      reference_id         = policy_definition_reference.key
    }
  }
}

resource "azurerm_management_group_policy_assignment" "hipaa_full_initiative" {
  name                 = "${local.init_prefix}-${local.app}-full-${local.env}-${local.loc}-${local.instance_count}-assignment"
  management_group_id  = var.platform_mg_id
  policy_definition_id = azurerm_policy_set_definition.hipaa_full_initiative.id
  description          = "Assigns the full custom HIPAA initiative to the platform management group"
}

resource "azurerm_management_group_policy_assignment" "hipaa_sandbox_initiative" {
  name                 = "${local.init_prefix}-${local.app}-sandbox-${local.env}-${local.loc}-${local.instance_count}-assignment"
  management_group_id  = var.sandbox_mg_id
  policy_definition_id = azurerm_policy_set_definition.hipaa_sandbox_initiative.id
  description          = "Assigns the limited custom HIPAA initiative to the sandbox management group"
}
