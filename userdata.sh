#!/bin/bash
set -e

# ─── Log everything ──────────────────────────────────────────
exec > /var/log/userdata.log 2>&1

echo "=== Starting LUXE setup ==="

# ─── System update ───────────────────────────────────────────
apt-get update -y
apt-get upgrade -y

# ─── Install Docker ──────────────────────────────────────────
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker

# ─── Install Docker Compose plugin ──────────────────────────
apt-get install -y docker-compose-plugin

# ─── Install Git ─────────────────────────────────────────────
apt-get install -y git

# ─── Clone the repo ──────────────────────────────────────────
cd /home/ubuntu
git clone ${github_repo} app
cd app

# ─── Inject secrets into docker-compose.yml ─────────────────
# Replace hardcoded values with the real secrets
sed -i "s|supersecretjwtkey_change_in_production|${jwt_secret}|g" docker-compose.yml
sed -i "s|ecom_pass|${db_password}|g" docker-compose.yml
sed -i "s|postgresql://ecom_user:ecom_pass@|postgresql://ecom_user:${db_password}@|g" docker-compose.yml

# ─── Fix ownership ───────────────────────────────────────────
chown -R ubuntu:ubuntu /home/ubuntu/app

# ─── Start the app ───────────────────────────────────────────
docker compose up -d --build

echo "=== LUXE setup complete ==="
echo "App running at: http://$(curl -s ifconfig.me):3000"
