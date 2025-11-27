# AKS Automatic Cluster with Azure Developer CLI

This project uses Azure Developer CLI (azd) to deploy an AKS Automatic cluster along with your applications.

## Prerequisites

- [Azure Developer CLI (azd)](https://aka.ms/azure-dev/install)
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- An Azure subscription

## Quick Start

### 1. Initialize the environment

```bash
azd init
```

When prompted:
- Enter an environment name (e.g., `dev`, `test`, `prod`)
- Select your Azure subscription
- Select a location (e.g., `eastus`, `westus2`)

### 2. Provision and deploy

To provision the infrastructure and deploy your applications:

```bash
azd up
```

This command will:
1. Create an AKS Automatic cluster
2. Create a Log Analytics workspace for monitoring
3. Build Docker images for your applications (if Dockerfiles exist)
4. Deploy the applications to AKS

### 3. Connect to your cluster

After deployment, get the credentials for your AKS cluster:

```bash
az aks get-credentials --resource-group <resource-group-name> --name <cluster-name>
```

You can find these values in the output of `azd up` or by running:

```bash
azd env get-values
```

## What's Deployed

### AKS Automatic Cluster

The Bicep templates create an AKS Automatic cluster with:

- **SKU**: Automatic (Standard tier)
- **Network**: Azure CNI Overlay with Cilium dataplane
- **Security**: 
  - Workload Identity enabled
  - Image Cleaner enabled
  - OIDC Issuer enabled
- **Auto-upgrade**: Stable channel
- **Node provisioning**: Auto mode (AKS manages node pools automatically)
- **Storage**: Disk, File, and Blob CSI drivers enabled
- **Monitoring**: Azure Monitor metrics enabled

### Log Analytics Workspace

A workspace for collecting logs and metrics from your cluster.

## Commands

### Provision infrastructure only

```bash
azd provision
```

### Deploy applications only

```bash
azd deploy
```

### View environment values

```bash
azd env get-values
```

### Tear down resources

```bash
azd down
```

## Infrastructure Structure

```
infra/
├── main.bicep                  # Main deployment file (subscription scope)
├── main.parameters.json        # Parameter values
└── modules/
    ├── aks.bicep              # AKS Automatic cluster
    └── log-analytics.bicep    # Log Analytics workspace
```

## AKS Automatic Features

AKS Automatic provides a managed Kubernetes experience with:

- **Automatic node provisioning**: Nodes are automatically created and scaled based on workload demands
- **Automatic upgrades**: Kubernetes version and node images are automatically updated
- **Built-in best practices**: Security and networking configurations follow Azure best practices
- **Simplified management**: Reduced operational overhead

For more information, see [AKS Automatic documentation](https://learn.microsoft.com/azure/aks/intro-aks-automatic).

## Next Steps

1. **Deploy your applications**: Add Kubernetes manifests or Helm charts
2. **Configure ingress**: Set up ingress controllers for external access
3. **Set up CI/CD**: Integrate with GitHub Actions or Azure DevOps
4. **Monitor your cluster**: Use Azure Monitor and Container Insights

## Troubleshooting

### View deployment logs

```bash
azd monitor
```

### Check resource status

```bash
az resource list --resource-group <resource-group-name> -o table
```

### Get AKS cluster details

```bash
az aks show --resource-group <resource-group-name> --name <cluster-name>
```
