targetScope = 'managementGroup'
resource Deny_Databricks_NoPublicIp 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Deny-Databricks-NoPublicIp'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Deny public IPs for Databricks cluster'
    description: 'Denies the deployment of workspaces that do not use the noPublicIp feature to host Databricks clusters without public IPs.'
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
            field: 'Microsoft.DataBricks/workspaces/parameters.enableNoPublicIp.value'
            notEquals: true
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}