targetScope = 'managementGroup'
resource Deny_Databricks_Sku 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Deny-Databricks-Sku'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Deny non-premium Databricks sku'
    description: 'Enforces the use of Premium Databricks workspaces to make sure appropriate security features are available including Databricks Access Controls, Credential Passthrough and SCIM provisioning for AAD.'
    metadata: {
      version: '1.0.0'
      category: 'Databricks'
    }
    parameters: {
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        allowedValues: [
          'Audit'
          'Disabled'
          'Deny'
        ]
        defaultValue: 'Deny'
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Databricks/workspaces'
          }
          {
            field: 'Microsoft.DataBricks/workspaces/sku.name'
            notEquals: 'premium'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}