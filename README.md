# NimbusShop – Infrastructure Azure avec OpenTofu (groupe 12)

## Architecture
- RG `rg-nimbus-g12`, VNet `10.12.0.0/16`
- `snet-web` 10.12.1.0/24 : 2 VM nginx (count), sans IP publique, derrière un Load Balancer Standard
- `snet-admin` 10.12.2.0/24 : jumpbox, seule entrée SSH (depuis notre IP)
- Sonde LB : GET /sante → OK-nimbus ; règle sortante explicite pour l'accès Internet des VM
- Alerte CPU > 80 % / 5 min → mail ; mot de passe aléatoire dans un Key Vault

## Fichiers
versions.tf, variables.tf, main.tf (réseau/NSG), web.tf (LB + VM), cloud-init.yaml,
jumpbox.tf, monitoring.tf, keyvault.tf, outputs.tf

## Utilisation
    az login
    cp terraform.tfvars.example terraform.tfvars   # remplir
    tofu init && tofu fmt && tofu validate
    tofu apply
    tofu destroy

## Sécurité
tfstate et tfvars exclus par .gitignore, authentification via az login,
aucune valeur personnelle en dur.
