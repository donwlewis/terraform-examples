# Azure Virtual Machine

In this example, we will create a virtual machine in Azure with with the following requirements:

- The virtual machine must be in the `westus2` region.
- The virtual machine must be in a private network.
- Configure virtual machine to use a username and a password.
- Configure virtual machine to use boot diagnostics for console access.

## How to Run

To keep it simple, we will leverage (Azure CLI)[https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli] authentication to run this Terraform code. Please refer to the documentation to instructions on how to do this.

Once logged in to Azure with `az cli`, run `terraform plan` in the [azure/vm](azure/vm) directory where the Terraform files are located. If the plan finishes successfully, run `terraform apply` to build the resources.

To retrieve the generated password for the VM account, run `terraform output password`.
