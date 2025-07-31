# ado_sh_agent

Requirenments:
terraform

1. Create storage account for terraform

terraform init
terraform plan
terraform apply 

terraform apply -auto-approve \
          -var="service_connection_object_id=${{ parameters.serviceConnectionObjectId }}" \
          -var="admin_object_id=${{ parameters.adminObjectId }}" \
          -var="tenant_id=$ARM_TENANT_ID"

2. Provision ubuntu machine
3. Run ansible script for agent provisioning