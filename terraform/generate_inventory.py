import json

with open("terraform/tf_output.json") as f:
    data = json.load(f)

public_ips = data["public_ips"]["value"]
private_ips = data["private_ips"]["value"]

bastion_ip = public_ips["bastion"]

inventory = f"""[web]
vm-web ansible_host={public_ips.get("web", private_ips["web"])} ansible_user=azureuser

[db]
vm-db ansible_host={private_ips["db"]} ansible_user=azureuser ansible_ssh_common_args='-o ProxyJump=azureuser@{bastion_ip}'

[monitoring]
vm-monitoring ansible_host={private_ips["monitoring"]} ansible_user=azureuser ansible_ssh_common_args='-o ProxyJump=azureuser@{bastion_ip}'

[bastion]
vm-bastion ansible_host={bastion_ip} ansible_user=azureuser
"""

with open("Ansible/inventory.ini", "w") as f:
    f.write(inventory)

print("[+] Inventory generated in inventory.ini")
