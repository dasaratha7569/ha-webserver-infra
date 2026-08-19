#!/bin/bash

terraform output -json web_public_ips \
| jq -r '.[]' > ips.txt

echo "[webservers]" > ../ansible/inventory.ini

cat ips.txt >> ../ansible/inventory.ini

echo "" >> ../ansible/inventory.ini
echo "[webservers:vars]" >> ../ansible/inventory.ini
echo "ansible_user=ec2-user" >> ../ansible/inventory.ini
echo "ansible_ssh_private_key_file=../terraform-key.pem" >> ../ansible/inventory.ini
