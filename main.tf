provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "wordpress" {
  name     = "wordpressResourceGroup"
  location = "eastus2"
}

resource "azurerm_virtual_network" "wordpress" {
  name                = "wordpress-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name
}

resource "azurerm_subnet" "wordpress" {
  name                 = "wordpress-subnet"
  resource_group_name  = azurerm_resource_group.wordpress.name
  virtual_network_name = azurerm_virtual_network.wordpress.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "wordpress" {
  name                = "wordpress-pip"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "wordpress" {
  name                = "wordpress-nic"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.wordpress.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.wordpress.id
  }
}

resource "azurerm_virtual_machine" "wordpress" {
  name                  = "wordpress-vm"
  location              = azurerm_resource_group.wordpress.location
  resource_group_name   = azurerm_resource_group.wordpress.name
  network_interface_ids = [azurerm_network_interface.wordpress.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "wordpress-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "wordpressvm"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data = base64encode(file("init-script.sh"))
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Testing"
  }


  depends_on = [azurerm_public_ip.wordpress]
}
