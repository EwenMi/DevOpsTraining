#!/bin/bash

set -e

cd ../terraform

echo "🔧 Initialisation Terraform..."
terraform init

echo "🚀 Application du plan Terraform..."
terraform apply -auto-approve

echo "🌐 Récupération de l'IP publique..."
IP=$(terraform output -raw public_ip)

cd ../Ansible

echo "✏️ Mise à jour de l'inventaire Ansible..."
echo "[web]" > inventory.ini
echo "$IP ansible_user=azureuser ansible_ssh_private_key_file=~/.ssh/id_rsa" >> inventory.ini

echo "🛠️ Déploiement avec Ansible..."
ansible-playbook -i inventory.ini playbook.yml

echo "✅ Déploiement terminé. Application disponible sur http://$IP"
