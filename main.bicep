targetScope = 'managementGroup'

param location string = deployment().location
param Assignment object = {
  name: 'MS-Cloud-Sec-Benchmark'
  displayname: 'Microsoft Cloud Security Benchmark'
  description: 'Microsoft Cloud Security Benchmark policy assignment including Overrides'
  definitionID: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
  parameters: {
    networkSecurityGroupsOnSubnetsMonitoringEffect: 'AuditIfNotExists'
    networkSecurityGroupsOnVirtualMachinesMonitoringEffect: 'AuditIfNotExists'
  }
  overrides: {
    Audit: [
      'sqlManagedInstanceADOnlyEnabledMonitoring' // Policy without initiative parameter
      'synapseWorkspaceADOnlyEnabledMonitoring' // Policy without initiative parameter
      'sqlServerADOnlyEnabledMonitoring' // Policy without initiative parameter
    ]
    AuditIfNotExists: [
      'mySqlServerADAdminisMonitoring' // Policy without initiative parameter
      'postgreSqlServerADAdminisMonitoring' // Policy without initiative parameter
      'mySqlServerADOnlyEnabledMonitoring' // Policy without initiative parameter
    ]
    Disabled: [
      'aPIManagementServiceShouldNotHaveAllApisScopedSubscriptions' // Policy without initiative parameter
      'aPIManagementServiceShouldNotBypassCertificateValidation' // Policy without initiative parameter
      'aPIManagementServiceShouldUseEncryptedProtocols' // Policy without initiative parameter
      'aPIManagementServiceShouldUseKeyVaultForSecretNamedValues' // Policy without initiative parameter
      'aPIManagementServiceShouldHaveDirectManagementEndpointDisabled' // Policy without initiative parameter
      'aPIManagementServiceShouldDisableServiceConfigurationEndpoints' // Policy without initiative parameter
      'aPIManagementServiceShouldHaveMinimumAPIVersionSet' // Policy without initiative parameter
      'aPIManagementServiceShouldHaveBackendCallsAuthenticated' // Policy without initiative parameter
    ]
    Deny: [
      'classicComputeVMsMonitoring' // Policy with initiative parameter but used in policy override
      'classicStorageAccountsMonitoring' // Policy with initiative parameter but used in policy override
    ]
  }
}

resource PolicyAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: Assignment.name
  location: location
  properties: {
    displayName: Assignment.displayname
    description: Assignment.description
    policyDefinitionId: Assignment.definitionID
    parameters: {
      networkSecurityGroupsOnSubnetsMonitoringEffect: {
        value: Assignment.parameters.networkSecurityGroupsOnSubnetsMonitoringEffect
      }
      networkSecurityGroupsOnVirtualMachinesMonitoringEffect: {
        value: Assignment.parameters.networkSecurityGroupsOnVirtualMachinesMonitoringEffect
      }
    }
    overrides: [
      {
        kind: 'policyEffect'
        value: 'Audit'
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: Assignment.overrides.Audit
          }
        ]
      }
      {
        kind: 'policyEffect'
        value: 'AuditIfNotExists'
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: Assignment.overrides.AuditIfNotExists
          }
        ]
      }
      {
        kind: 'policyEffect'
        value: 'Disabled'
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: Assignment.overrides.Disabled
          }
        ]
      }
      {
        kind: 'policyEffect'
        value: 'Deny'
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: Assignment.overrides.Deny
          }
        ]
      }
    ]
  }
}
