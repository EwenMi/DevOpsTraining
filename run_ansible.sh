#!/bin/bash

set -e

echo "🛠️ Génération des fichiers inventory..."
./generate_inventories.sh

echo "🚀 Déploiement du bastion..."
ansible-playbook -i inventory_bastion.ini Ansible/bastion.yml

echo "✅ Bastion configuré. Passage aux autres machines..."

ansible-playbook -i inventory_via_bastion.ini Ansible/site.yml
echo "✅ Déploiement terminé !"