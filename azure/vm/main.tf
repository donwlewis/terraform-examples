# Resource Group Creation
resource "azurerm_resource_group" "main" {
  name     = "exampleResourceGroup"
  location = "westus2"
}

# Virtual Network Creation

## Create Private Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "exampleVirtualNetwork"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/24"]
}

## Create Private Subnet
resource "azurerm_subnet" "main" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/28"]

}

# Virtual Machine Resources Creation

## Create a password for our server
resource "random_password" "vm" {
  length  = 8
  special = true
}

## Create Storage Account so We Can Use the Console
resource "azurerm_storage_account" "diagnostic" {
  name                     = "ubuntustorageaccount"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_account_network_rules" "main" {
  storage_account_id = azurerm_storage_account.diagnostic.id
  default_action     = "Allow"
  bypass             = ["Logging", "Metrics", "AzureServices"]
}


## Create Virtual Network Interface
resource "azurerm_network_interface" "main" {
  name                = "private"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "dhcp"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

## Create and Customize Virtual Machine
resource "azurerm_linux_virtual_machine" "ubuntu" {
  name                            = "ubuntuVM"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  network_interface_ids           = [azurerm_network_interface.main.id]
  size                            = "Standard_DS1_v2"
  admin_username                  = "azureadmin"
  admin_password                  = random_password.vm.result
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "osDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diagnostic.primary_blob_endpoint
  }
}
