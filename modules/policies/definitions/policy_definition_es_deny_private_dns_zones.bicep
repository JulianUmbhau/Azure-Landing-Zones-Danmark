targetScope = 'managementGroup'
resource Deny_Private_DNS_Zones 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Deny-Private-DNS-Zones'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Deny the creation of private DNS'
    description: 'This policy denies the creation of a private DNS in the current scope, used in combination with policies that create centralized private DNS in connectivity subscription'
    metadata: {
      version: '1.0.0'
      category: 'Network'
    }
    parameters: {
      effect: {
        type: 'String'
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Deny'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
      }
    }
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.Network/privateDnsZones'
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}