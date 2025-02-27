targetScope = 'managementGroup'
resource Audit_MachineLearning_PrivateEndpointId 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Audit-MachineLearning-PrivateEndpointId'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Control private endpoint connections to Azure Machine Learning'
    description: 'Audit private endpoints that are created in other subscriptions and/or tenants for Azure Machine Learning.'
    metadata: {
      version: '1.0.0'
      category: 'Machine Learning'
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
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Audit'
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.MachineLearningServices/workspaces/privateEndpointConnections'
          }
          {
            field: 'Microsoft.MachineLearningServices/workspaces/privateEndpointConnections/privateLinkServiceConnectionState.status'
            equals: 'Approved'
          }
          {
            anyOf: [
              {
                field: 'Microsoft.MachineLearningServices/workspaces/privateEndpointConnections/privateEndpoint.id'
                exists: false
              }
              {
                value: '[split(concat(field(\'Microsoft.MachineLearningServices/workspaces/privateEndpointConnections/privateEndpoint.id\'), \'//\'), \'/\')[2]]'
                notEquals: '[subscription().subscriptionId]'
              }
            ]
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}