### Create an unmanaged cluster

Create a few on-premises Kubernetes clusters. This is simulated using k3s by Rancher running on a single Azure VM.

1. Open [**Cloud Shell**](https://shell.azure.com/)
2. Execute this code to create a resource group

```bash
LOCATION=uksouth

RG_ID=$(az group create -n "rg-arc4k8s-${LOCATION}" -l "${LOCATION}" -o tsv --query 'id')
AZURE_CREDENTIALS=$(az ad sp create-for-rbac -n "http://AzureArcK8s-${LOCATION}" --sdk-auth --role contributor --scopes $RG_ID)

echo "Copy this output into a GitHub secret with the name: 'AZURE_CREDENTIALS_${LOCATION^^}'"
echo "You will use this to allow GitHub to deploy the appropriate resources"

echo $AZURE_CREDENTIALS
```

3. Create a child repository from this template
4. Add a secret with value of the `AZURE_CREDENTIALS` output
5. Run the **Deploy Cluster** workflow
