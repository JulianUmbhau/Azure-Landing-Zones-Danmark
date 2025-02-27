targetScope = 'managementGroup'
resource Deny_MachineLearning_HbiWorkspace 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Deny-MachineLearning-HbiWorkspace'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Enforces high business impact Azure Machine Learning Workspaces'
    description: 'Enforces high business impact Azure Machine Learning workspaces.'
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
            equals: 'Microsoft.MachineLearningServices/workspaces'
          }
          {
            anyOf: [
              {
                field: 'Microsoft.MachineLearningServices/workspaces/hbiWorkspace'
                exists: false
              }
              {
                field: 'Microsoft.MachineLearningServices/workspaces/hbiWorkspace'
                notEquals: true
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