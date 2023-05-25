targetScope = 'managementGroup'

param location string = deployment().location
param Assignment object = {
  name: 'MS-Cloud-Sec-Benchmark'
  displayname: 'Microsoft Cloud Security Benchmark'
  description: 'Microsoft Cloud Security Benchmark policy assignment including Overrides'
  definitionID: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
}
@allowed([
  'Disabled'
  'AuditIfNotExists'
])
param networkSecurityGroupsOnSubnetsMonitoringEffect string = 'AuditIfNotExists'

@allowed([
  'Disabled'
  'AuditIfNotExists'
])
param networkSecurityGroupsOnVirtualMachinesMonitoringEffect string = 'AuditIfNotExists'

param auditEffect object = {
  type: 'Audit'
  policyDefinitionReferenceIds: [
    'sqlManagedInstanceADOnlyEnabledMonitoring' // Policy without initiative parameter
    'synapseWorkspaceADOnlyEnabledMonitoring' // Policy without initiative parameter
    'sqlServerADOnlyEnabledMonitoring' // Policy without initiative parameter
  ]
}

param AuditIfNotExistsEffect object = {
  type: 'AuditIfNotExists'
  policyDefinitionReferenceIds: [
    'mySqlServerADAdminisMonitoring' // Policy without initiative parameter
    'postgreSqlServerADAdminisMonitoring' // Policy without initiative parameter
    'mySqlServerADOnlyEnabledMonitoring' // Policy without initiative parameter
  ]
}

param disabledEffect object = {
  type: 'Disabled'
  policyDefinitionReferenceIds: [
    'aPIManagementServiceShouldNotHaveAllApisScopedSubscriptions' // Policy without initiative parameter
    'aPIManagementServiceShouldNotBypassCertificateValidation' // Policy without initiative parameter
    'aPIManagementServiceShouldUseEncryptedProtocols' // Policy without initiative parameter
    'aPIManagementServiceShouldUseKeyVaultForSecretNamedValues' // Policy without initiative parameter
    'aPIManagementServiceShouldHaveDirectManagementEndpointDisabled' // Policy without initiative parameter
    'aPIManagementServiceShouldDisableServiceConfigurationEndpoints' // Policy without initiative parameter
    'aPIManagementServiceShouldHaveMinimumAPIVersionSet' // Policy without initiative parameter
    'aPIManagementServiceShouldHaveBackendCallsAuthenticated' // Policy without initiative parameter
  ]
}

param denyEffect object = {
  type: 'Deny'
  policyDefinitionReferenceIds: [
    'classicComputeVMsMonitoring' // Policy with initiative parameter but used in policy override
    'classicStorageAccountsMonitoring' // Policy with initiative parameter but used in policy override
  ]
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
        value: networkSecurityGroupsOnSubnetsMonitoringEffect
      }
      networkSecurityGroupsOnVirtualMachinesMonitoringEffect: {
        value: networkSecurityGroupsOnVirtualMachinesMonitoringEffect
      }
    }
    overrides: [
      {
        kind: 'policyEffect'
        value: auditEffect.type
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: auditEffect.policyDefinitionReferenceIds
          }
        ]
      }
      {
        kind: 'policyEffect'
        value: AuditIfNotExistsEffect.type
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: AuditIfNotExistsEffect.policyDefinitionReferenceIds
          }
        ]
      }
      {
        kind: 'policyEffect'
        value: disabledEffect.type
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: disabledEffect.policyDefinitionReferenceIds
          }
        ]
      }
      {
        kind: 'policyEffect'
        value: denyEffect.type
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: denyEffect.policyDefinitionReferenceIds
          }
        ]
      }
    ]
  }
}
