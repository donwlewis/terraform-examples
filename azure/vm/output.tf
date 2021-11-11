output "password" {
  description = "The password generated for the VM administrator account."
  value       = azurerm_linux_virtual_machine.ubuntu.admin_password
  sensitive   = true
}
