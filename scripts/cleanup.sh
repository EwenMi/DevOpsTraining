#!/bin/bash

cd terraform

echo "🔥 Suppression des ressources Azure..."
terraform destroy -auto-approve

cd ..

echo "🧹 Nettoyage de l'inventaire..."
rm -f inventory.ini

echo "✅ Infrastructure détruite proprement."
