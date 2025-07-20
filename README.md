# Home Server GitOps

A GitOps repository for managing a complete home server infrastructure using Docker Compose. This setup provides media automation, home automation, monitoring, and various utilities across multiple VMs with centralized reverse proxy and authentication.

> **⚠️ Personal Use & Learning Project**  
> This repository is designed for my personal home lab and learning purposes. It contains specific configurations, domain names, and architectural decisions tailored to my environment. **Please do not fork this repository directly.** Instead, use it as a reference and inspiration for building your own home lab setup with your own configurations, domains, and security settings.

## 🏗️ Architecture

### Infrastructure Overview

The setup consists of multiple VMs connected via Tailscale, with external access through a VPS running Caddy reverse proxy:

- **VPS (Ubuntu)**: External-facing server with Caddy reverse proxy, Cloudflare DNS integration, and SSL termination
- **home-server**: Primary server running core services, databases, and monitoring
- **plexvm**: Dedicated Plex media server
- **homeassistant**: Home automation hub

### Network Diagram

```
                             +-----------------------+
                             |     Cloudflare DNS    |
                             |-----------------------|
                             | rossboss.dev → VPS IP |
                             +-----------------------+
                                         |
                                         v
                          +-----------------------------+
                          |        VPS (Ubuntu)         |
                          |-----------------------------|
                          | - Caddy Reverse Proxy       |
                          | - Portainer                 |
                          | - Tailscale (tunnel)        |
                          +-----------------------------+
                               |        |        |
                               |        |        |
                               v        v        v
       +----------------+  +----------------+  +------------------+
       | home-server    |  | plexvm         |  | homeassistant    |
       +----------------+  +----------------+  +------------------+
```

### Traffic Flow

1. **External Request** → Cloudflare DNS → VPS IP
2. **Caddy Reverse Proxy** → SSL termination, OAuth2 authentication
3. **Tailscale Tunnel** → Route to appropriate home network VM
4. **Backend Service** → Process request and return response

## 🚀 Services

### Media Automation Stack (`media-server.yml`)
- **Overseerr**: Media request management and discovery
- **Radarr**: Movie collection management
- **Sonarr**: TV series collection management  
- **Prowlarr**: Indexer management for *arr services
- **NZBGet**: Usenet download client
- **Bazarr**: Subtitle management
- **Tautulli**: Plex usage analytics and monitoring
- **Maintainerr**: Automated media library cleanup
- **Plex Recommendations**: AI-powered movie recommendations
- **Posteria**: Custom Plex poster management
- **Unpackerr**: Automatic archive extraction

### Core Infrastructure Stack (`home-server.yml`)
- **OAuth2 Proxy**: Google OAuth authentication layer
- **Pi-hole**: Network-wide ad blocking and DNS filtering
- **Watchtower**: Automatic container updates
- **Backrest**: Backup management with restic
- **Lunalytics**: Custom analytics platform
- **PostgreSQL**: Primary database server
- **Redis**: Caching and message broker
- **Activepieces**: Workflow automation platform

### Monitoring Stack
- **Prometheus**: Metrics collection and storage
- **Grafana**: Metrics visualization and dashboards
- **cAdvisor**: Container performance metrics

### VPS Stack (`vps.yml`)
- **Caddy**: Reverse proxy with automatic HTTPS and Cloudflare integration

## 🔐 Authentication & Security

### OAuth2 Integration
Protected services use OAuth2 Proxy with Google OAuth for authentication:
- **Protected Services**: Radarr, Sonarr, Prowlarr, Bazarr, NZBGet, Home Assistant
- **Public Services**: Overseerr, Plex, Tautulli, Grafana

### SSL & DNS
- **Automatic HTTPS**: Let's Encrypt certificates via Caddy
- **DNS Challenge**: Cloudflare API for certificate validation
- **Custom Domains**: All services accessible via `*.rossreicks.com` subdomains

## 📦 Deployment

### Prerequisites
- Docker and Docker Compose installed on all VMs
- Tailscale configured for inter-VM communication
- Cloudflare account with API token
- Google OAuth application for authentication

### Environment Variables
Create `.env` files with required variables:

```bash
# OAuth2 Configuration
OAUTH2_PROXY_CLIENT_ID=your_google_client_id
OAUTH2_PROXY_CLIENT_SECRET=your_google_client_secret
OAUTH2_PROXY_COOKIE_SECRET=your_cookie_secret
OAUTH2_PROXY_EMAIL_DOMAINS=your_allowed_domain.com
OAUTH2_PROXY_BASIC_AUTH_PASSWORD=your_basic_auth_password

# External Services
CLOUDFLARE_API_TOKEN=your_cloudflare_token
PLEX_TOKEN=your_plex_token
OPEN_AI_KEY=your_openai_key

# Database
POSTGRES_USER=your_postgres_user
POSTGRES_PASSWORD=your_postgres_password

# Service APIs
SONARR_API_KEY=your_sonarr_api_key
RADARR_API_KEY=your_radarr_api_key
PIHOLE_WEBPASSWORD=your_pihole_password

# Downloads
NZBGET_USER=your_nzbget_user
NZBGET_PASS=your_nzbget_password

# Application Keys
AP_API_KEY=your_activepieces_api_key
AP_ENCRYPTION_KEY=your_activepieces_encryption_key
AP_JWT_SECRET=your_activepieces_jwt_secret
```

### Deploy Services

```bash
# Deploy VPS stack (external proxy)
cd docker/stacks
docker compose -f vps.yml up -d

# Deploy home server stack (core services)
docker compose -f home-server.yml up -d

# Deploy media server stack (arr services)
docker compose -f media-server.yml up -d
```

### Access Services

Once deployed, services are accessible via:
- **Overseerr**: https://overseerr.rossreicks.com
- **Plex**: https://plex.rossreicks.com  
- **Grafana**: https://grafana.rossreicks.com
- **Pi-hole**: https://pihole.rossreicks.com
- **Tautulli**: https://tautulli.rossreicks.com
- **Protected services require OAuth2 authentication**

## 📁 Repository Structure

```
├── docker/stacks/           # Active Docker Compose configurations
│   ├── home-server.yml      # Core infrastructure services
│   ├── media-server.yml     # Media automation stack
│   ├── vps.yml             # VPS reverse proxy
│   ├── Caddyfile           # Caddy configuration
│   └── prometheus/         # Prometheus configuration
├── old-kubernetes-cluster/ # Legacy Kubernetes setup (reference)
└── .github/workflows/      # GitHub Actions (disabled)
```

## 🔧 Maintenance

### Container Updates
Watchtower automatically updates containers daily. Manual updates:
```bash
docker compose -f <stack-file> pull
docker compose -f <stack-file> up -d
```

### Backup Management
Backrest provides automated backup management. Access the UI at https://backrest.rossreicks.com

### Monitoring
- **System Metrics**: Available in Grafana dashboards
- **Media Analytics**: Tautulli for Plex usage statistics
- **Custom Analytics**: Lunalytics for additional insights

## 🗂️ Legacy Setup

The `old-kubernetes-cluster/` directory contains the previous Kubernetes-based setup using Helm and helmfile. This has been migrated to the current Docker Compose setup but is kept for reference.
