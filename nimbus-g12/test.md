# ===== NIVEAU 1 : SITE HAUTEMENT DISPONIBLE =====

# Affiche l'URL du site (output demandé par le sujet)
tofu output site_url

# Envoie 10 requêtes au Load Balancer → prouve la répartition de charge (alternance vm-web-1 / vm-web-2)
1..10 | ForEach-Object { curl.exe -s http://9.205.248.7 }

# Appelle la page de santé → doit répondre OK-nimbus (c'est elle que la sonde du LB utilise)
curl.exe http://9.205.248.7/sante

# Éteint vm-web-1 → pour simuler une panne
az vm stop -g rg-nimbus-g12 -n vm-web1-nimbus-g12

# Relance les requêtes → ne doit répondre que vm-web-2 : prouve la haute disponibilité
1..10 | ForEach-Object { curl.exe -s http://9.205.248.7 }

# Rallume vm-web-1 → elle revient dans le pool après ~30 s
az vm start -g rg-nimbus-g12 -n vm-web1-nimbus-g12


# ===== NIVEAU 2 : JUMPBOX =====

# Se connecte à une VM web en rebondissant par la jumpbox → prouve que le SSH passe par la jumpbox
ssh -J azureuser@9.205.248.154 azureuser@10.12.1.4

#   (sur la VM) Affiche le nom de la machine → prouve qu'on est bien sur une VM web
hostname

#   (sur la VM) Affiche l'IP publique de sortie → 9.205.248.7 : prouve l'accès sortant via la règle sortante du LB
curl -s ifconfig.me; echo

#   (sur la VM) Quitte la VM
exit

# Tente un SSH direct → doit expirer : prouve que les VM web ne sont pas joignables depuis Internet
ssh -o ConnectTimeout=5 azureuser@9.205.248.7


# ===== NIVEAU 3 : SUPERVISION + SECRETS =====

# Lit le mot de passe dans le Key Vault → prouve que le secret est stocké et lisible seulement avec les droits
az keyvault secret show --vault-name kv-nimbus-g12-wnku -n admin-password --query value

# Affiche tous les outputs → prouve que le mot de passe n'y apparaît pas
tofu output

# Cherche "password" dans le code → prouve qu'il n'y a que la référence, jamais la valeur
Select-String -Path *.tf -Pattern "password"

# (Mail) Montrer le mail Azure du groupe d'actions + Portail → Monitor → Alertes → Règles d'alerte


# ===== GESTION =====

# Vérifie que le code est bien formaté → aucune sortie = OK
tofu fmt -check -recursive

# Vérifie que le code est valide → doit afficher Success!
tofu validate

# Liste les fichiers suivis par git → aucun .tfvars / .tfstate / backend.hcl ne doit apparaître
git status

# Affiche le .gitignore → prouve que les secrets sont exclus du dépôt
type .gitignore


# ===== FIN =====

# Ajoute tous les fichiers au commit
git add .

# Crée le commit
git commit -m "NimbusShop g12"

# Envoie le code sur le dépôt distant
git push

# Supprime toute l'infra Azure (obligatoire à la fin)
tofu destroy