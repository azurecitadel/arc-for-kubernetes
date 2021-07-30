# Application Setup

This deploys the set of infrastructure required to run the application

The main components of the application are:

* Azure SQL for storing data
* Azure Storage for storing binary blob uploads
* Azure Applicaiton for enabling single sign on

No secret credentials are stored or created during deployment as all authentication is handled by Azure AD, including access to the database and storage.

## Database

1. Determine who will be the **database administrator**
2. Find the **Object ID** in Azure AD that corresponds to your identity

## Storage

1. Nothing special is required here

## Application Registration

1. You will need to take note of your **Tenant ID** and **Application ID**

# Troubleshooting

* 
