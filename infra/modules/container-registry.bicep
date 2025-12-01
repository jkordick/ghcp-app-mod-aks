@description('Name of the container registry')
param name string

@description('Location for the container registry')
param location string = resourceGroup().location

@description('Tags for the container registry')
param tags object = {}

@description('SKU for the container registry')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Basic'

@description('Object ID of the AKS kubelet identity for ACR pull')
param aksKubeletIdentityObjectId string = ''

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: true
    publicNetworkAccess: 'Enabled'
  }
}

// Grant AKS pull permissions to ACR if kubelet identity is provided
resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(aksKubeletIdentityObjectId)) {
  name: guid(containerRegistry.id, aksKubeletIdentityObjectId, 'acrpull')
  scope: containerRegistry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // AcrPull role
    principalId: aksKubeletIdentityObjectId
    principalType: 'ServicePrincipal'
  }
}

output registryName string = containerRegistry.name
output registryLoginServer string = containerRegistry.properties.loginServer
output registryId string = containerRegistry.id
