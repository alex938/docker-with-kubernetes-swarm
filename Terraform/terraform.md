# Terraform

```terraform
terraform init
terraform plan

Destroy:
terraform apply -var="create_vm=false" -auto-approve
terraform apply -var="create_dev2_vm=false" -auto-approve -target=proxmox_vm_qemu.dev2_labjunkie_org

Create:
terraform apply -var="create_vm=true" -auto-approve
terraform apply -var="create_dev2_vm=true" -auto-approve -target=proxmox_vm_qemu.dev2_labjunkie_org
```
