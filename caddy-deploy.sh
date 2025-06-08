#!/bin/bash
# Simple script to pull the latest Caddyfile and reload Caddy
# Run from the root of the repo
# need to chmod +x this file first
cd /opt/caddy || exit 1
git pull origin main
caddy reload --config /opt/caddy/Caddyfile
