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

param Audit_policyDefinitionReferenceIds array = [
  'sqlManagedInstanceADOnlyEnabledMonitoring' // Policy without initiative parameter
  'synapseWorkspaceADOnlyEnabledMonitoring' // Policy without initiative parameter
  'sqlServerADOnlyEnabledMonitoring' // Policy without initiative parameter
]

param AuditIfNotExists_policyDefinitionReferenceIds array = [
  'mySqlServerADAdminisMonitoring' // Policy without initiative parameter
  'postgreSqlServerADAdminisMonitoring' // Policy without initiative parameter
  'mySqlServerADOnlyEnabledMonitoring' // Policy without initiative parameter
]

param Disbaled_policyDefinitionReferenceIds array = [
  'aPIManagementServiceShouldNotHaveAllApisScopedSubscriptions' // Policy without initiative parameter
  'aPIManagementServiceShouldNotBypassCertificateValidation' // Policy without initiative parameter
  'aPIManagementServiceShouldUseEncryptedProtocols' // Policy without initiative parameter
  'aPIManagementServiceShouldUseKeyVaultForSecretNamedValues' // Policy without initiative parameter
  'aPIManagementServiceShouldHaveDirectManagementEndpointDisabled' // Policy without initiative parameter
  'aPIManagementServiceShouldDisableServiceConfigurationEndpoints' // Policy without initiative parameter
  'aPIManagementServiceShouldHaveMinimumAPIVersionSet' // Policy without initiative parameter
  'aPIManagementServiceShouldHaveBackendCallsAuthenticated' // Policy without initiative parameter
]

param Deny_policyDefinitionReferenceIds array = [
  'classicComputeVMsMonitoring' // Policy with initiative parameter but used in policy override
  'classicStorageAccountsMonitoring' // Policy with initiative parameter but used in policy override
]

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
        value: 'Audit'
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: Audit_policyDefinitionReferenceIds
          }
        ]
      }
      {
        kind: 'policyEffect'
        value: 'AuditIfNotExists'
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: AuditIfNotExists_policyDefinitionReferenceIds
          }
        ]
      }
      {
        kind: 'policyEffect'
        value: 'Disabled'
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: Disbaled_policyDefinitionReferenceIds
          }
        ]
      }
      {
        kind: 'policyEffect'
        value: 'Deny'
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: Deny_policyDefinitionReferenceIds
          }
        ]
      }
    ]
  }
}
