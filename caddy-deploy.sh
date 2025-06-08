#!/bin/bash
# Simple script to pull the latest Caddyfile and reload Caddy
# Run from the root of the repo
# need to chmod +x this file first
set -e

CADDYFILE=/etc/caddy/Caddyfile

echo "[1/3] Validating Caddyfile..."
caddy validate --config "$CADDYFILE"

echo "[2/3] Pulling latest changes (if any)..."
cd /opt/caddy && git pull

echo "[3/3] Restarting Caddy..."
sudo systemctl restart caddy

echo "✅ Deploy complete!"
