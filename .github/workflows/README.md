# GitHub Actions CI/CD Workflows

This directory contains GitHub Actions workflows for deploying infrastructure and applications to Azure Kubernetes Service (AKS).

## Workflows

### 1. Infrastructure Deployment (`infrastructure.yml`)

Deploys Azure infrastructure using Bicep templates.

**Triggers:**
- Push to `main` branch when `infra/**` files change
- Manual workflow dispatch

**What it does:**
- Deploys resource group, AKS cluster, Log Analytics, and Azure Container Registry
- Configures AKS cluster credentials
- Outputs deployment information

### 2. Python App Deployment (`python-app.yml`)

Builds and deploys the Customer Profile API (Python/FastAPI).

**Triggers:**
- Push to `main` branch when `python-app/**` or `manifests/python-app.yaml` changes
- Manual workflow dispatch

### 3. JavaScript App Deployment (`js-app.yml`)

Builds and deploys the Insurance Quote API (Node.js/Express).

**Triggers:**
- Push to `main` branch when `js-app/**` or `manifests/js-app.yaml` changes
- Manual workflow dispatch

### 4. Java App Deployment (`java-app.yml`)

Builds and deploys the Insurance Claims API (Java/Spring Boot).

**Triggers:**
- Push to `main` branch when `java-app/**` or `manifests/java-app.yaml` changes
- Manual workflow dispatch

## Setup Instructions

### 1. Create Azure Service Principal

Create a service principal with contributor access to your subscription:

```bash
az ad sp create-for-rbac \
  --name "github-actions-aks-deployment" \
  --role contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID> \
  --sdk-auth
```

This will output JSON credentials. Copy the entire JSON output.

### 2. Configure GitHub Secrets

Add the following secrets to your GitHub repository (Settings → Secrets and variables → Actions → New repository secret):

#### Required Secrets:

- **`AZURE_CREDENTIALS`**: The JSON output from the service principal creation above

#### Required Variables (or Secrets):

After running the infrastructure deployment once, add these as repository variables or secrets:

- **`AZURE_RESOURCE_GROUP`**: The resource group name (from infrastructure deployment output)
- **`AKS_CLUSTER_NAME`**: The AKS cluster name (from infrastructure deployment output)
- **`AZURE_CONTAINER_REGISTRY_NAME`**: The ACR name (from infrastructure deployment output)

### 3. Configure GitHub Environments (Optional)

For better control and approval gates, configure environments:

1. Go to Settings → Environments
2. Create environments: `dev`, `staging`, `prod`
3. Configure environment protection rules (required reviewers, wait timers, etc.)
4. Add environment-specific secrets/variables if needed

## Deployment Order

### First-Time Setup:

1. **Deploy Infrastructure First**
   ```
   Go to Actions → Deploy Infrastructure → Run workflow
   Select environment: dev
   Click "Run workflow"
   ```

2. **After infrastructure deployment completes**, add the output values to GitHub secrets/variables:
   - AZURE_RESOURCE_GROUP
   - AKS_CLUSTER_NAME
   - AZURE_CONTAINER_REGISTRY_NAME

3. **Deploy Applications** (in any order):
   - Run Python App workflow
   - Run JavaScript App workflow
   - Run Java App workflow

### Subsequent Deployments:

Changes to application code will automatically trigger deployments when pushed to the `main` branch.

## Manual Deployment

You can manually trigger any workflow:

1. Go to **Actions** tab in GitHub
2. Select the workflow you want to run
3. Click **Run workflow**
4. Select the environment (dev/staging/prod)
5. Optionally specify a custom image tag
6. Click **Run workflow**

## Workflow Features

### All Application Workflows Include:

- ✅ **Build & Test**: Runs tests before deployment (Maven for Java, npm for JS, pytest for Python)
- ✅ **Docker Build**: Builds container images with versioned tags
- ✅ **Push to ACR**: Pushes images to Azure Container Registry
- ✅ **Deploy to AKS**: Applies Kubernetes manifests
- ✅ **Health Checks**: Verifies deployment success and service availability
- ✅ **Smoke Tests**: Tests health endpoints after deployment
- ✅ **Rollback Support**: Uses Kubernetes rollout status checks

### Image Tagging Strategy:

- **Default**: Uses Git commit SHA (first 7 characters)
- **Manual**: Can specify custom tag via workflow dispatch
- **Latest**: Always pushes `latest` tag for each deployment

## Monitoring Deployments

### View Workflow Runs:
- Go to the **Actions** tab in GitHub
- Click on a workflow run to see detailed logs
- Check the job summary for deployment information and endpoints

### Access Deployed Applications:

After deployment, the workflow outputs the external IP address. Access applications at:

- Python App: `http://<EXTERNAL_IP>/health`
- JavaScript App: `http://<EXTERNAL_IP>/health`
- Java App: `http://<EXTERNAL_IP>/api/claims/health`

### Troubleshooting:

Check logs directly in AKS:

```bash
# Get cluster credentials
az aks get-credentials --resource-group <RG_NAME> --name <AKS_NAME>

# Check pod status
kubectl get pods

# View logs
kubectl logs -l app=<APP_NAME>

# Check deployment status
kubectl get deployment <APP_NAME>
```

## Best Practices

1. **Always deploy infrastructure first** in a new environment
2. **Use environments** for production deployments with approval gates
3. **Monitor the Actions tab** for deployment status
4. **Check AKS cluster** after deployment for pod health
5. **Use manual triggers** for controlled deployments to production
6. **Tag releases** in Git for tracking production deployments

## Security Notes

- Service Principal credentials are stored as GitHub secrets
- ACR authentication is handled via Azure CLI
- AKS uses managed identity for ACR access
- Never commit secrets to the repository

## Customization

### Change Environments:

Edit the `environment` input in workflow files to add more environments:

```yaml
options:
  - dev
  - staging
  - prod
  - test
```

### Modify Resource Names:

Update the `APP_NAME` environment variable in each workflow file.

### Change Triggers:

Modify the `on:` section to change when workflows run (e.g., add pull request triggers).

## Support

For issues or questions:
1. Check the Actions tab for detailed error logs
2. Review the Kubernetes deployment status
3. Check Azure Portal for resource status
4. Review application logs in AKS
