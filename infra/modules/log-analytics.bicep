targetScope = 'resourceGroup'

@description('Name of the Log Analytics workspace')
param name string

@description('Location for the workspace')
param location string = resourceGroup().location

@description('Tags to apply to the workspace')
param tags object = {}

@description('SKU for the Log Analytics workspace')
param sku string = 'PerGB2018'

@description('Retention period in days')
param retentionInDays int = 30

// Generate unique suffix for resource names
var resourceToken = toLower(uniqueString(subscription().id, resourceGroup().name, name))
var workspaceName = '${name}-${resourceToken}'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

output workspaceId string = logAnalyticsWorkspace.id
output workspaceName string = logAnalyticsWorkspace.name
output customerId string = logAnalyticsWorkspace.properties.customerId
