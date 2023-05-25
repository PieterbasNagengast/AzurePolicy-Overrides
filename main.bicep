targetScope = 'managementGroup'

param location string = deployment().location
param Assignment object = {
  name: 'Microsoft cloud security benchmark'
  definitionID: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
}

param auditEffect object = {
  type: 'audit'
  policyDefinitionReferenceIds: [
    'sqlServerADOnlyEnabledMonitoring'
    'mySqlServerADAdminisMonitoring'
    'postgreSqlServerADAdminisMonitoring'
    'sqlManagedInstanceADOnlyEnabledMonitoring'
    'synapseWorkspaceADOnlyEnabledMonitoring'
    'mySqlServerADOnlyEnabledMonitoring'
  ]
}

param disabledEffect object = {
  type: 'disbaled'
  policyDefinitionReferenceIds: [
    'aPIManagementServiceShouldNotHaveAllApisScopedSubscriptions'
    'aPIManagementServiceShouldNotBypassCertificateValidation'
    'aPIManagementServiceShouldUseEncryptedProtocols'
    'aPIManagementServiceShouldUseKeyVaultForSecretNamedValues'
    'aPIManagementServiceShouldHaveDirectManagementEndpointDisabled'
    'aPIManagementServiceShouldDisableServiceConfigurationEndpoints'
    'aPIManagementServiceShouldHaveMinimumAPIVersionSet'
    'aPIManagementServiceShouldHaveBackendCallsAuthenticated'
  ]
}

resource PolicyAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: Assignment.name
  location: location
  properties: {
    policyDefinitionId: Assignment.definitionID
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
        value: disabledEffect.type
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: disabledEffect.policyDefinitionReferenceIds
          }
        ]
      }
    ]
  }
}
