#!/bin/bash

SP_USERNAME=""
SP_PASSWORD=""
TENANT_ID=""

RESOURCE_GROUP_NAME="z-buildagent-rg"
LOCATION="westeurope"
STORAGE_ACCOUNT_NAME="devops123123"
CONTAINER_NAME="tfstate"

az login --service-principal \
  --username "$SP_USERNAME" \
  --password "$SP_PASSWORD" \
  --tenant "$TENANT_ID"

az group create \
  --name "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION"

az storage account create \
  --name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2

STORAGE_KEY=$(az storage account keys list \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --query '[0].value' \
  --output tsv)

az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --account-key "$STORAGE_KEY" \
  --public-access off
