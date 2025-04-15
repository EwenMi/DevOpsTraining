variable "vm_definitions" {
  default = {
    web = {
      name      = "vm-web"
      public_ip = true
    }
    db = {
      name      = "vm-db"
      public_ip = false
    }
    monitoring = {
      name      = "vm-monitoring"
      public_ip = false
    }
    bastion = {
      name      = "vm-bastion"
      public_ip = true
    }
  }
}

resource "azurerm_public_ip" "public_ips" {
  for_each = {
    for k, v in var.vm_definitions : k => v if v.public_ip
  }

  name                = "${each.value.name}-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "nics" {
  for_each = var.vm_definitions

  name                = "${each.value.name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = each.value.public_ip ? azurerm_public_ip.public_ips[each.key].id : null
  }
}

resource "azurerm_linux_virtual_machine" "vms" {
  for_each = var.vm_definitions

  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nics[each.key].id
  ]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${each.value.name}-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
