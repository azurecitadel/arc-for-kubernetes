# Create an unmanaged cluster

Create a few on-premises Kubernetes clusters. This is simulated using k3s by Rancher running on a single Azure VM.

## Login to Azure

1. Open [**Cloud Shell**](https://shell.azure.com/)
2. Execute this code to create a resource group and copy the credential output

```bash
LOCATION=uksouth
# - or -
LOCATION=westeurope
```

## Create a new resource group
```bash
RG_ID=$(az group create -n "arc4k8s-${LOCATION}" -l "${LOCATION}" -o tsv --query 'id')
AZURE_CREDENTIALS=$(az ad sp create-for-rbac --sdk-auth --role Owner --name http://arc4k8s-ghaction-$LOCATION --scopes $RG_ID)

echo "Copy this output into a GitHub secret with the name: 'AZURE_CREDENTIALS_${LOCATION^^}'"
echo "You will use this to allow GitHub to deploy the appropriate resources"

echo $AZURE_CREDENTIALS

```

## Set up Team repo

3. [Create a child repository](//github.com/jasoncabot-ms/arc-for-kubernetes/generate) from this template, you can call it something like `arc-for-kubernetes` but the name doesn't matter
4. Add a secret called `AZURE_CREDENTIALS_<region>` with value of the `AZURE_CREDENTIALS` output. The name does not matter but you will use it when you run the workflow to deploy a cluster to know which secret to access.
> This secret allows GitHub access to Azure resources within the resource group created in Step 2

As an example, your GitHub repository should appear like this
![Secret values](https://user-images.githubusercontent.com/51163690/127553360-4c52f2a0-ce42-4240-a3df-b2b4f7d0e47a.png)

## Deploy Kubernetes using GitHub

5. Run the **Deploy Cluster** workflow from [GitHub Actions](../../actions) specifying the secret name you added in step 4

![run workflow](https://user-images.githubusercontent.com/51163690/127536787-11b0f118-e368-43c6-8926-61fcda7acbda.png)


### Troubleshooting

1. Ensure you create a Service Principal with appropriate access, especially note the `sdk-auth` for appropriate formatting of the secret and `scopes` for what you want the GitHub Action to be able to modify
2. If you get a status code 400 error when creating the Service Principal, try to login to the Azure CLI again using `az login`
3. If your deployment fails, look at the logs and check for `The template deployment failed with error` and `The requested size for resource is currently not available in location '...' zones '...' for subscription '...'. Please try another size or deploy to a different location or zones. See https://aka.ms/azureskunotavailable`
