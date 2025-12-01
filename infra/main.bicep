targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Tags to apply to all resources')
param tags object = {}

// Generate unique suffix for resource names
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
// Use shorter token to keep names under limits
var shortToken = take(resourceToken, 8)
var resourceGroupName = 'rg-${environmentName}-${shortToken}'

// Create the resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: union(tags, {
    'azd-env-name': environmentName
  })
}

// Deploy AKS Automatic cluster
module aks 'modules/aks.bicep' = {
  name: 'aks-deployment'
  scope: resourceGroup
  params: {
    name: 'aks-${environmentName}'
    location: location
    tags: tags
  }
}

// Deploy Log Analytics Workspace for monitoring
module logAnalytics 'modules/log-analytics.bicep' = {
  name: 'log-analytics-deployment'
  scope: resourceGroup
  params: {
    name: 'log-${environmentName}'
    location: location
    tags: tags
  }
}

// Deploy Azure Container Registry
module containerRegistry 'modules/container-registry.bicep' = {
  name: 'container-registry-deployment'
  scope: resourceGroup
  params: {
    name: 'acr${shortToken}'
    location: location
    tags: tags
    sku: 'Standard'
  }
}

// Outputs
output AZURE_RESOURCE_GROUP string = resourceGroup.name
output AKS_CLUSTER_NAME string = aks.outputs.clusterName
output AKS_CLUSTER_ID string = aks.outputs.clusterId
output LOG_ANALYTICS_WORKSPACE_ID string = logAnalytics.outputs.workspaceId
output AZURE_CONTAINER_REGISTRY_NAME string = containerRegistry.outputs.registryName
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerRegistry.outputs.registryLoginServer
