variable "subscription_id" {
  type        = string
  description = "ID de l'abonnement Azure for Students"
}

variable "location" {
  type        = string
  description = "Région Azure retenue lors du TP Azure"
}

variable "vm_size" {
  type        = string
  description = "Taille des VM retenue lors du TP Azure"
}

variable "binome" {
  type        = string
  description = "Identifiant du binôme utilisé dans les noms de ressources"
  default     = "g12"
}

variable "group_number" {
  type        = number
  description = "Numéro du groupe, utilisé pour l'adressage 10.<groupe>.0.0/16"
  default     = 12
}

variable "owner" {
  type        = string
  description = "Valeur du tag owner (noms du binôme)"
}

variable "env" {
  type        = string
  description = "Valeur du tag env"
  default     = "dev"
}

variable "admin_username" {
  type        = string
  description = "Utilisateur administrateur des VM"
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Chemin local de la clé publique SSH"
}

variable "admin_ip" {
  type        = string
  description = "IP publique autorisée en SSH sur la jumpbox (format CIDR, ex: 1.2.3.4/32)"
}

variable "alert_email" {
  type        = string
  description = "Adresse mail qui reçoit les alertes CPU"
}