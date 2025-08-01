#!/bin/bash

SP_USERNAME=""
SP_PASSWORD=""
TENANT_ID=""

RESOURCE_GROUP_NAME="z-buildagent-rg"
LOCATION="westeurope"
STORAGE_ACCOUNT_NAME="devops123123"
CONTAINER_NAME="tfstate"
# KEY_VAULT_NAME="strangekvtestss2"

ADMIN_OBJECT_ID="your-admin-object-id"
SERVICE_CONN_OBJECT_ID="your-service-conn-object-id"

az login --service-principal \
  --username "$SP_USERNAME" \
  --password "$SP_PASSWORD" \
  --tenant "$TENANT_ID"

# 1. Create Resource Group
az group create \
  --name "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION"

# 2. Create Storage Account
az storage account create \
  --name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2

# 3. Get Storage Account Key
STORAGE_KEY=$(az storage account keys list \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --query '[0].value' \
  --output tsv)

# 4. Create Storage Container
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --account-key "$STORAGE_KEY" \
  --public-access off

# 5. Create Key Vault
# az keyvault create \
#   --name "$KEY_VAULT_NAME" \
#   --resource-group "$RESOURCE_GROUP_NAME" \
#   --location "$LOCATION" \
#   --enabled-for-deployment true \
#   --enabled-for-template-deployment true

# 6. Set Key Vault Access Policies
# az keyvault set-policy \
#   --name "$KEY_VAULT_NAME" \
#   --resource-group "$RESOURCE_GROUP_NAME" \
#   --object-id "$ADMIN_OBJECT_ID" \
#   --secret-permissions get list set delete

# az keyvault set-policy \
#   --name "$KEY_VAULT_NAME" \
#   --resource-group "$RESOURCE_GROUP_NAME" \
#   --object-id "$SERVICE_CONN_OBJECT_ID" \
#   --secret-permissions get list
