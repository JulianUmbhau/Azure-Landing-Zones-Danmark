targetScope = 'managementGroup'
resource network_deny_nsg_rule_inbound_from_internet_can_check_if_port_is_present_in_range_network_security_group 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'network_deny_nsg_rule_inbound_from_internet_can_check_if_port_is_present_in_range_network_security_group'
  properties: {
    displayName: 'Deny NSG rule inbound from internet - Network Security Group'
    description: 'This Policy will detect if an NSG rule would allow a port or set of ports to be accessed from outside of an IP whitelist. This will check Service Tags as well as Port Ranges. Example, if you specify port 22 in the parameter for this Policy, and only allow communications from 10.0.0.0/8, and someone creates a rule that allows ports 20-30 inbound from 20.x.x.x, this would be denied as 22 falls within that port range and 20.x.x.x is not on the IP whitelist. This Policy is part of a set of policies. Both must be applied for this to cover all possible ways an NSG rule can be created.'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Network/networkSecurityGroups'
          }
          {
            count: {
              field: 'Microsoft.Network/networkSecurityGroups/securityRules[*]'
              where: {
                allOf: [
                  {
                    field: 'Microsoft.Network/networkSecurityGroups/securityRules[*].access'
                    equals: 'Allow'
                  }
                  {
                    field: 'Microsoft.Network/networkSecurityGroups/securityRules[*].direction'
                    equals: 'Inbound'
                  }
                  {
                    anyOf: [
                      {
                        count: {
                          value: '[parameters(\'allowedIPRanges\')]'
                          name: 'allowedIPRanges'
                          where: {
                            value: '[ipRangeContains(current(\'allowedIPRanges\'), if(or(or(greaterOrEquals(first(current(\'Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefix\')), \'a\'), equals(current(\'Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefix\'), \'*\')), empty(current(\'Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefix\'))), current(\'allowedIPRanges\'), current(\'Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefix\')))]'
                            equals: true
                          }
                        }
                        equals: 0
                      }
                      {
                        count: {
                          field: 'Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefixes[*]'
                          where: {
                            count: {
                              value: '[parameters(\'allowedIPRanges\')]'
                              name: 'allowedIPRanges'
                              where: {
                                value: '[ipRangeContains(current(\'allowedIPRanges\'), if(empty(current(\'Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefixes[*]\')), current(\'allowedIPRanges\'), current(\'Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefixes[*]\')))]'
                                equals: true
                              }
                            }
                            equals: 0
                          }
                        }
                        greater: 0
                      }
                      {
                        field: 'Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefix'
                        equals: '*'
                      }
                      {
                        field: 'Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefix'
                        equals: 'Internet'
                      }
                    ]
                  }
                  {
                    count: {
                      value: '[parameters(\'destinationPort\')]'
                      name: 'destinationPort'
                      where: {
                        anyOf: [
                          {
                            value: '[if(empty(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRange\')), bool(\'false\'), if(contains(string(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRange\')), \'*\'), bool(\'true\'), and(greaterOrEquals(int(current(\'destinationPort\')), int(first(split(substring(string(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRange\')), 2, sub(length(string(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRange\'))), 4)), \'-\')))), lessOrEquals(int(current(\'destinationPort\')), int(last(split(substring(string(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRange\')), 2, sub(length(string(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRange\'))), 4)), \'-\')))))))]'
                            equals: true
                          }
                          {
                            count: {
                              field: 'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRanges[*]'
                              where: {
                                value: '[if(empty(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRanges[*]\')), bool(\'false\'), if(contains(string(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRanges[*]\')), \'*\'), bool(\'true\'), and(greaterOrEquals(int(current(\'destinationPort\')), int(first(split(substring(string(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRanges[*]\')), 2, sub(length(string(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRanges[*]\'))), 4)), \'-\')))), lessOrEquals(int(current(\'destinationPort\')), int(last(split(substring(string(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRanges[*]\')), 2, sub(length(string(field(\'Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRanges[*]\'))), 4)), \'-\')))))))]'
                                equals: true
                              }
                            }
                            greater: 0
                          }
                        ]
                      }
                    }
                    greater: 0
                  }
                ]
              }
            }
            greater: 0
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
    parameters: {
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Policy Effect'
          description: 'Sets the effect of the Policy. Useful for when the Policy is part of an initiative.'
        }
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Audit'
      }
      destinationPort: {
        type: 'Array'
        metadata: {
          displayName: 'destinationPort'
          description: null
        }
      }
      allowedIPRanges: {
        type: 'Array'
        metadata: {
          displayName: 'allowedIPRanges'
          description: null
        }
      }
    }
  }
}
