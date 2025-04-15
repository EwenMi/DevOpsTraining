#!/bin/bash

# Récupérer les IPs via Terraform
BASTION_IP=$(terraform -chdir=terraform output -raw bastion_public_ip)
WEB_IP=$(terraform -chdir=terraform output -raw web_private_ip)
DB_IP=$(terraform -chdir=terraform output -raw db_private_ip)
MONITORING_IP=$(terraform -chdir=terraform output -raw monitoring_private_ip)

SSH_USER="azureuser"

# Inventory pour Bastion uniquement (accès direct)
cat > inventory_bastion.ini <<EOF
[bastion]
vm-bastion ansible_host=$BASTION_IP ansible_user=$SSH_USER
EOF

# Inventory pour les autres (via bastion)
cat > inventory_via_bastion.ini <<EOF
[web]
vm-web ansible_host=$WEB_IP ansible_user=$SSH_USER

[db]
vm-db ansible_host=$DB_IP ansible_user=$SSH_USER

[monitoring]
vm-monitoring ansible_host=$MONITORING_IP ansible_user=$SSH_USER 

[all:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa_devops
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyJump=$SSH_USER@$BASTION_IP'
EOF
