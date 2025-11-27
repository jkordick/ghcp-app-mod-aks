targetScope = 'resourceGroup'

@description('Name of the AKS cluster')
param name string

@description('Location for the AKS cluster')
param location string = resourceGroup().location

@description('Tags to apply to the AKS cluster')
param tags object = {}

@description('Kubernetes version')
param kubernetesVersion string = '1.31'

// Generate unique suffix for resource names
var resourceToken = toLower(uniqueString(subscription().id, resourceGroup().name, name))
var clusterName = '${name}-${resourceToken}'

// Create user-assigned managed identity for the cluster
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-${clusterName}'
  location: location
  tags: tags
}

// Create AKS Automatic cluster
resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-09-02-preview' = {
  name: clusterName
  location: location
  tags: union(tags, {
    'azd-service-name': 'aks'
  })
  sku: {
    name: 'Base'
    tier: 'Standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: clusterName
    enableRBAC: true
    
    // Agent pool profile - required even for Automatic mode
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 3
        vmSize: 'Standard_DS4_v2'
        mode: 'System'
        osType: 'Linux'
        osSKU: 'AzureLinux'
        osDiskType: 'Ephemeral'
        osDiskSizeGB: 0
        availabilityZones: [
          '2'
        ]
      }
    ]
    
    // Network profile for AKS Automatic
    networkProfile: {
      networkPlugin: 'azure'
      networkPluginMode: 'overlay'
      networkDataplane: 'cilium'
      networkPolicy: 'cilium'
      loadBalancerSku: 'standard'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
    }
    
    // Auto-upgrade configuration
    autoUpgradeProfile: {
      upgradeChannel: 'stable'
      nodeOSUpgradeChannel: 'NodeImage'
    }
    
    // Security profile
    securityProfile: {
      workloadIdentity: {
        enabled: true
      }
      imageCleaner: {
        enabled: true
        intervalHours: 168
      }
    }
    
    // OIDC Issuer for workload identity
    oidcIssuerProfile: {
      enabled: true
    }
    
    // Azure Monitor integration
    azureMonitorProfile: {
      metrics: {
        enabled: true
      }
    }
    
    // Storage profile
    storageProfile: {
      diskCSIDriver: {
        enabled: true
      }
      fileCSIDriver: {
        enabled: true
      }
      blobCSIDriver: {
        enabled: true
      }
    }
  }
}

output clusterName string = aksCluster.name
output clusterId string = aksCluster.id
output clusterFqdn string = aksCluster.properties.fqdn
output oidcIssuerUrl string = aksCluster.properties.oidcIssuerProfile.issuerURL
output identityPrincipalId string = managedIdentity.properties.principalId
output identityClientId string = managedIdentity.properties.clientId
