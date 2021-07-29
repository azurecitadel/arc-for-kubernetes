#!/bin/bash

TENANT_ID=$1
SUBSCRIPTION_ID=$2
RESOURCE_GROUP=$3

sudo rm -r "/etc/kubernetes/azure.json"

echo "{
  \"cloud\": \"AzurePublicCloud\",
  \"tenantId\": \"$TENANT_ID\",
  \"subscriptionId\": \"$SUBSCRIPTION_ID\",
  \"resourceGroup\": \"$RESOURCE_GROUP\",
  \"useManagedIdentityExtension\": true
}" | sudo tee /etc/kubernetes/azure.json
