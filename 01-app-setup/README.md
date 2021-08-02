# Application Infrastructure Setup

This deploys the set of infrastructure required to run the application

The main components of the application are:

* Azure SQL for storing data
* Azure Storage for storing binary blob uploads
* Azure Application for enabling single sign on

No secret credentials are stored or created during deployment as all authentication is handled by Azure AD, including access to the database and storage.

## Database and Storage

1. Determine who will be the **database administrator**
2. Find the **Object ID** in Azure AD that corresponds to their identity

```bash
az ad signed-in-user show --query 'objectId' -o tsv # aad_admin_objectid
```

> Note: You would ideally use a group identity here rather than a single user, for example a group called "Azure Arc SQL Server Admins" however creating an Azure AD group is a privileged operation that you may not have access to

3. Run the **Deploy Infrastructure** workflow from [GitHub Actions](../../actions) specifying the secret name you added previously e.g. `AZURE_CREDENTIALS_WESTEUROPE`

## User Authentication

To allow users to sign-in to your deployment of the application you will need to register a new application with Azure AD since it requires unique and specific Reply URLs (the allowed set of URIs that a user is redirected to after signing into Azure AD)

You only need to do this once. The same application can be shared for all running instances of the Reviewer application provided that you include all Reply URLs

This step should have been automatically handled as part of the GitHub action. Look in Azure AD for an application called "Item Reviewer ......" and check the Reply URLs. Looking in the output log of the GitHub Action run should give you a good indication of the work done.

# Application Setup

## Create SQL Schema

All infrastructure will now be provisioned so it's time to create the DB schema. The SQL Server we deployed has [Azure AD Authentication Only](https://docs.microsoft.com/azure/azure-sql/database/authentication-azure-ad-only-authentication?tabs=azure-cli) so without allowing admin access to a group that the GitHub Action also has access to we can't yet deploy changes automatically. This mean you will need to log in to your server manually and deploy a few resources to allow the application to work.

1. Download [Azure Data Studio](https://azure.microsoft.com/services/developer-tools/data-studio/)
2. Find the **connection details** in the output of your GitHub Action run
3. Connect to SQL Server as the **database administrator** (Azure AD Admin specified earlier)
4. Deploy the [Application Schema](../scripts/schema.sql)
5. Create [contained users](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-sql#create-contained-user) by executing the following code

```sql
CREATE USER [id-reviewer-api] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [id-reviewer-api];
```

# Troubleshooting

* Can't create an Azure AD group for the DB Admin. This can happen if you aren't an Admin of your Azure AD tenant or have otherwise been restricted from creating groups. As a workaround you can set just one person as the DB administrator by finding their Azure AD Object ID.