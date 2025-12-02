@description('Name of the Azure Container Registry')
param acrName string

@description('Object ID of the AKS kubelet identity')
param kubeletIdentityObjectId string

// Reference the existing ACR
resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: acrName
}

// AcrPull role definition ID
var acrPullRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

// Assign AcrPull role to AKS kubelet identity
resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, kubeletIdentityObjectId, acrPullRoleDefinitionId)
  scope: acr
  properties: {
    roleDefinitionId: acrPullRoleDefinitionId
    principalId: kubeletIdentityObjectId
    principalType: 'ServicePrincipal'
  }
}

output roleAssignmentId string = acrPullRoleAssignment.id
