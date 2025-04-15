# IP publique du bastion
output "bastion_public_ip" {
  value = azurerm_public_ip.public_ips["bastion"].ip_address
}

# IP privée de chaque machine
output "web_private_ip" {
  value = azurerm_network_interface.nics["web"].private_ip_address
}

output "db_private_ip" {
  value = azurerm_network_interface.nics["db"].private_ip_address
}

output "monitoring_private_ip" {
  value = azurerm_network_interface.nics["monitoring"].private_ip_address
}
