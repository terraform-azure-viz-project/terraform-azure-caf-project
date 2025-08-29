variable "management_group_id" {
  description = "The ID of the management group to apply policies"
  type        = string
}

# Create custom policy definitions from JSON files
resource "azurerm_policy_definition" "custom_policies" {
  for_each = fileset("${path.module}/json_policies/common", "*.json")

  name         = "${replace(basename(each.value), ".json", "")}-custom"  # Unique name to avoid conflicts
  display_name = try(
    jsondecode(file("${path.module}/json_policies/common/${each.value}")).displayName,
    jsondecode(file("${path.module}/json_policies/common/${each.value}")).properties.displayName,
    "Default Display Name"
  )
  policy_type  = "Custom"
  mode         = try(
    jsondecode(file("${path.module}/json_policies/common/${each.value}")).mode,
    jsondecode(file("${path.module}/json_policies/common/${each.value}")).properties.mode,
    "All"
  )
  description  = try(
    jsondecode(file("${path.module}/json_policies/common/${each.value}")).description,
    jsondecode(file("${path.module}/json_policies/common/${each.value}")).properties.description,
    null
  )
  metadata     = try(
    jsonencode(jsondecode(file("${path.module}/json_policies/common/${each.value}")).metadata),
    jsonencode(jsondecode(file("${path.module}/json_policies/common/${each.value}")).properties.metadata),
    null
  )
  parameters   = try(
    jsonencode(jsondecode(file("${path.module}/json_policies/common/${each.value}")).parameters),
    jsonencode(jsondecode(file("${path.module}/json_policies/common/${each.value}")).properties.parameters),
    jsonencode({})
  )
  policy_rule  = try(
    jsonencode(jsondecode(file("${path.module}/json_policies/common/${each.value}")).policyRule),
    jsonencode(jsondecode(file("${path.module}/json_policies/common/${each.value}")).properties.policyRule),
    null
  )

  management_group_id = var.management_group_id

  lifecycle {
    ignore_changes = [metadata]  # Ignore if metadata changes post-creation
  }
}

# Create custom initiative (policy set) referencing the custom policies
resource "azurerm_policy_set_definition" "custom_hipaa_initiative" {
  name                = "custom-hipaa-initiative"
  policy_type         = "Custom"
  display_name        = "Custom HITRUST/HIPAA"
  description         = "Custom version of HIPAA HITRUST initiative"
  management_group_id = var.management_group_id

  parameters = jsonencode({})  # Add parameters from hipaa_initiative.json if needed

  dynamic "policy_definition_reference" {
    for_each = azurerm_policy_definition.custom_policies
    content {
      policy_definition_id = policy_definition_reference.value.id
      parameter_values     = jsonencode({})  # Map parameters from hipaa_initiative.json's policyDefinitions if needed
      reference_id         = policy_definition_reference.key  # Use file name as reference ID
    }
  }
}

# Assign the custom initiative to the management group
resource "azurerm_management_group_policy_assignment" "hipaa_assignment" {
  name                 = "custom-hipaa-assignment"
  display_name         = "Custom HIPAA Assignment"
  policy_definition_id = azurerm_policy_set_definition.custom_hipaa_initiative.id
  management_group_id  = var.management_group_id
  description          = "Assignment of custom HIPAA initiative"
  parameters           = jsonencode({})  # Add any initiative parameters here
}
