#!/bin/bash
# Simple script to pull the latest Caddyfile and reload Caddy
# to setup, run:
# sudo mkdir -p /opt/caddy
# sudo chown $USER /opt/caddy
# cd /opt/caddy
# git clone https://github.com/RossBossDev/home-gitops .
set -e

CADDYFILE=/opt/caddy/Caddyfile

echo "[1/3] Pulling latest changes (if any)..."
cd /opt/caddy && git pull

echo "[2/3] Validating Caddyfile..."
caddy validate --config "$CADDYFILE"

echo "[3/3] Restarting Caddy..."
sudo systemctl restart caddy

echo "✅ Deploy complete!"
