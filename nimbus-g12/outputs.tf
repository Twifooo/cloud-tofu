output "site_url" {
  description = "URL du site NimbusShop"
  value       = "http://${azurerm_public_ip.lb.ip_address}"
}

output "jumpbox_ip" {
  description = "IP publique de la jumpbox"
  value       = azurerm_public_ip.jumpbox.ip_address
}

output "ssh_web_commands" {
  description = "Commandes SSH vers les VM web via la jumpbox"
  value = [
    for nic in azurerm_network_interface.web :
    "ssh -J ${var.admin_username}@${azurerm_public_ip.jumpbox.ip_address} ${var.admin_username}@${nic.private_ip_address}"
  ]
}

output "key_vault_name" {
  description = "Nom du Key Vault (la valeur du secret n'est jamais affichée)"
  value       = azurerm_key_vault.main.name
}