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

// Note: ACR integration will be configured via az aks update command after deployment
// This avoids requiring Microsoft.Authorization/roleAssignments/write permissions

output registryName string = containerRegistry.name
output registryLoginServer string = containerRegistry.properties.loginServer
output registryId string = containerRegistry.id
