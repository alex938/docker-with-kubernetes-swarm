# Terraform

terraform init
terraform plan

Destroy:
terraform apply -var="create_vm=false" -auto-approve

Create:
terraform apply -var="create_vm=true" -auto-approve
