#!/bin/bash

./login.sh
	
myrg="blobstoragerg"
myVM="TestVm"

az group create --name $myrg --location westeurope

az deployment group create \
  --name BlobStorageDeployment \
  --resource-group $myrg \
  --template-file blob_pl.json \
  --parameters '@blob_pl.parameters.json'
 
adlsStorageAccountName=$(az resource list --query "[?contains(name, 'adls')].name" --out tsv | sed -e 's/\r//g')
spID=$(az resource list -n $myVM --query [*].identity.userAssignedIdentities.*.principalId --out tsv | sed -e 's/\r//g')

# Assign VM UAMI to storage account
az role assignment create \
  --assignee-object-id $spID \
  --assignee-principal-type ServicePrincipal \
  --role 'Reader' \
  --scope "/subscriptions/${subscription_id}/resourceGroups/${myrg}/providers/Microsoft.Storage/storageAccounts/${adlsStorageAccountName}"
