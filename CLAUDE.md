# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a GitOps repository for managing a home server infrastructure using Docker Compose. The infrastructure consists of multiple VMs running media services, automation tools, monitoring, and utilities with Caddy as a reverse proxy providing SSL termination and OAuth2 authentication.

## Architecture

### Current Setup (Docker Compose)
The active deployment uses Docker Compose across multiple VMs:

- **VPS (Ubuntu)**: Runs Caddy reverse proxy with Cloudflare DNS integration
- **home-server**: Primary server with core services
- **plexvm**: Dedicated Plex media server
- **homeassistant**: Home automation server

### Service Stacks
- **Media Stack** (`docker/stacks/media-server.yml`): Overseerr, Prowlarr, Radarr, Sonarr, Bazarr, NZBGet, Tautulli, Maintainerr, Plex Recommendations
- **Home Server Stack** (`docker/stacks/home-server.yml`): OAuth2 Proxy, Pi-hole, Watchtower, Backrest, Lunalytics, PostgreSQL, Redis, Activepieces, Prometheus, Grafana, cAdvisor
- **VPS Stack** (`docker/stacks/vps.yml`): Caddy reverse proxy with Cloudflare integration

## Network Topology

Services are exposed through Caddy reverse proxy on the VPS, which routes traffic to appropriate backend services across the home network via Tailscale tunnel:

```
Cloudflare DNS → VPS (Caddy) → Tailscale → Home Network VMs
```

Authentication is handled by OAuth2 Proxy (Google OAuth) for protected services, with some services (like Overseerr, Plex) exposed without authentication.

## Key Files and Directories

### Active Configuration
- `docker/stacks/`: Docker Compose files for each service stack
- `docker/stacks/Caddyfile`: Caddy reverse proxy configuration with OAuth2 integration
- `docker/stacks/prometheus/prometheus.yml`: Prometheus monitoring configuration

### Legacy Configuration
- `old-kubernetes-cluster/`: Previous Kubernetes setup (kept for reference)
  - Contains Helm charts, Kubernetes manifests, and Ansible playbooks
  - `old-kubernetes-cluster/helmfile.yaml`: Helm release definitions
  - `old-kubernetes-cluster/ansible/`: Ansible automation for Caddy deployment

## Deployment

### Docker Compose Deployment
Deploy individual stacks using Docker Compose:

```bash
# Deploy VPS stack (Caddy)
cd docker/stacks && docker compose -f vps.yml up -d

# Deploy home server stack
cd docker/stacks && docker compose -f home-server.yml up -d

# Deploy media server stack
cd docker/stacks && docker compose -f media-server.yml up -d
```

### Environment Variables
Services require environment variables for:
- OAuth2 configuration (Google client credentials)
- API keys for external services (Cloudflare, Plex, OpenAI)
- Database credentials
- Service-specific authentication tokens

Variables are referenced in compose files as `${VARIABLE_NAME}` and must be provided via `.env` files or environment.

### GitHub Actions
- `.github/workflows/deploy-caddy.yml`: Automated Caddy deployment using Ansible (currently disabled)

## Service Categories

### Media Management
- **Overseerr**: Media request management
- **Radarr/Sonarr**: Movie/TV show management
- **Prowlarr**: Indexer management
- **NZBGet**: Download client
- **Bazarr**: Subtitle management
- **Tautulli**: Plex analytics
- **Maintainerr**: Media library cleanup
- **Plex Recommendations**: AI-powered recommendations

### Infrastructure
- **Caddy**: Reverse proxy with automatic HTTPS
- **Pi-hole**: DNS filtering and ad blocking
- **OAuth2 Proxy**: Authentication layer
- **Watchtower**: Automatic container updates
- **Backrest**: Backup management

### Monitoring & Analytics
- **Prometheus**: Metrics collection
- **Grafana**: Metrics visualization
- **cAdvisor**: Container metrics
- **Lunalytics**: Custom analytics

### Databases & Automation
- **PostgreSQL**: Primary database
- **Redis**: Caching and message queuing
- **Activepieces**: Workflow automation

## Security

- HTTPS termination handled by Caddy with Let's Encrypt certificates
- OAuth2 authentication for admin services via Google OAuth
- DNS challenges for certificate generation using Cloudflare API
- Services isolated by Docker networks where appropriate
- Sensitive services protected behind authentication proxy

## Monitoring

Prometheus scrapes metrics from:
- Prometheus itself
- Container metrics via cAdvisor
- Custom application metrics where available

Grafana provides visualization dashboards for system and application metrics.