# Setup Guide

This guide walks through the complete setup process for the home server infrastructure.

## Prerequisites

### Hardware Requirements
- **VPS**: Ubuntu server with public IP (1GB RAM, 10GB storage minimum)
- **Home Server**: Docker-capable machine (4GB+ RAM, adequate storage for media)
- **Plex VM**: Dedicated server for Plex (optional but recommended for performance)
- **Home Assistant**: Raspberry Pi or dedicated machine for home automation

### Software Requirements
- Docker and Docker Compose on all machines
- Tailscale accounts and installation
- Cloudflare account with domain
- Google Cloud account for OAuth2

## Initial Configuration

### 1. Domain and DNS Setup

1. **Configure Cloudflare**:
   - Add your domain to Cloudflare
   - Create A record pointing `rossboss.dev` to your VPS IP
   - Create CNAME records for all subdomains pointing to your domain
   - Generate API token with DNS edit permissions

2. **Subdomain List**:
   ```
   overseerr.rossreicks.com
   plex.rossreicks.com
   tautulli.rossreicks.com
   radarr.rossreicks.com
   sonarr.rossreicks.com
   prowlarr.rossreicks.com
   bazarr.rossreicks.com
   nzb.rossreicks.com
   pihole.rossreicks.com
   grafana.rossreicks.com
   activepieces.rossreicks.com
   backrest.rossreicks.com
   ha.rossreicks.com
   auth.rossreicks.com
   ```

### 2. OAuth2 Setup

1. **Google Cloud Console**:
   - Create new project or use existing
   - Enable Google+ API
   - Create OAuth2 credentials (Web application)
   - Add authorized redirect URIs:
     ```
     https://auth.rossreicks.com/oauth2/callback
     ```

2. **Generate Cookie Secret**:
   ```bash
   openssl rand -base64 32
   ```

### 3. Tailscale Network

1. **Install Tailscale** on all machines:
   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   tailscale up
   ```

2. **Configure Machine Names**:
   - VPS: Keep default or set to `vps`
   - Home server: `home-server`
   - Plex server: `plexvm` 
   - Home Assistant: `homeassistant`

3. **Note Internal IPs** for configuration:
   ```bash
   tailscale ip -4
   ```

### 4. Storage Setup

**Home Server Storage Structure**:
```
/config/                    # Container configuration
├── pihole/
├── overseerr/
├── radarr/
├── sonarr/
├── prowlarr/
├── bazarr/
├── nzbget/
├── tautulli/
├── activepieces/
├── backrest/
├── grafana/
├── postgres/
├── redis/
├── lunalytics/
└── maintainerr/

/datapool/media/           # Media storage
├── downloads/             # Download directory
├── media/
│   ├── movies/           # Plex movie library
│   ├── tv/               # Plex TV library
│   └── posters/          # Custom posters
└── backups/
    └── repos/            # Backup repositories
```

## Environment Configuration

### 1. Create Environment Files

Create `.env` files in the `docker/stacks/` directory on each machine:

**VPS (.env)**:
```bash
CLOUDFLARE_API_TOKEN=your_cloudflare_token
```

**Home Server (.env)**:
```bash
# OAuth2 Configuration
OAUTH2_PROXY_CLIENT_ID=your_google_client_id
OAUTH2_PROXY_CLIENT_SECRET=your_google_client_secret
OAUTH2_PROXY_COOKIE_SECRET=your_32_char_cookie_secret
OAUTH2_PROXY_EMAIL_DOMAINS=yourdomain.com
OAUTH2_PROXY_BASIC_AUTH_PASSWORD=your_basic_auth_password

# Database
POSTGRES_USER=your_postgres_user
POSTGRES_PASSWORD=your_secure_postgres_password

# Service APIs (configure after initial setup)
SONARR_API_KEY=
RADARR_API_KEY=
PIHOLE_WEBPASSWORD=your_pihole_admin_password

# Downloads
NZBGET_USER=your_nzbget_username
NZBGET_PASS=your_nzbget_password

# External Services
PLEX_TOKEN=your_plex_token
OPEN_AI_KEY=your_openai_api_key

# Activepieces
AP_API_KEY=your_generated_api_key
AP_ENCRYPTION_KEY=your_generated_encryption_key
AP_JWT_SECRET=your_generated_jwt_secret
```

### 2. Generate Secrets

```bash
# For Activepieces
openssl rand -hex 16  # AP_API_KEY
openssl rand -hex 32  # AP_ENCRYPTION_KEY  
openssl rand -hex 32  # AP_JWT_SECRET

# For OAuth2 Proxy
openssl rand -base64 32  # OAUTH2_PROXY_COOKIE_SECRET
openssl rand -base64 32  # OAUTH2_PROXY_BASIC_AUTH_PASSWORD
```

## Deployment Process

### 1. Deploy VPS Stack

```bash
# On VPS
cd /path/to/gitops/docker/stacks
docker compose -f vps.yml up -d
```

Verify Caddy is running and can access Cloudflare:
```bash
docker logs caddy
```

### 2. Deploy Home Server Stack

```bash
# On home server
cd /path/to/gitops/docker/stacks
docker compose -f home-server.yml up -d
```

### 3. Deploy Media Server Stack

```bash
# On home server (or dedicated media server)
cd /path/to/gitops/docker/stacks
docker compose -f media-server.yml up -d
```

## Post-Deployment Configuration

### 1. Configure Core Services

1. **Pi-hole** (https://pihole.rossreicks.com):
   - Login with `PIHOLE_WEBPASSWORD`
   - Configure upstream DNS servers
   - Add custom DNS entries for local services

2. **OAuth2 Proxy**:
   - Test authentication at https://auth.rossreicks.com
   - Verify protected services redirect properly

### 2. Configure Media Stack

1. **Prowlarr** (https://prowlarr.rossreicks.com):
   - Add indexers
   - Configure API keys
   - Test indexer connections

2. **Radarr** (https://radarr.rossreicks.com):
   - Add root folder: `/movies`
   - Configure quality profiles
   - Add Prowlarr as indexer
   - Add NZBGet as download client
   - Copy API key to environment file

3. **Sonarr** (https://sonarr.rossreicks.com):
   - Add root folder: `/tv`
   - Configure quality profiles
   - Add Prowlarr as indexer
   - Add NZBGet as download client
   - Copy API key to environment file

4. **NZBGet** (https://nzb.rossreicks.com):
   - Configure usenet providers
   - Set download directory: `/downloads`
   - Configure post-processing scripts

5. **Overseerr** (https://overseerr.rossreicks.com):
   - Connect to Plex server
   - Add Radarr and Sonarr services
   - Configure user permissions

### 3. Configure Monitoring

1. **Grafana** (https://grafana.rossreicks.com):
   - Default login: admin/admin
   - Add Prometheus data source: `http://prometheus:9090`
   - Import dashboards for Docker monitoring

2. **Prometheus**:
   - Verify targets are being scraped
   - Add additional scrape configs as needed

## Troubleshooting

### Common Issues

1. **Services not accessible externally**:
   - Check Caddy logs: `docker logs caddy`
   - Verify Cloudflare DNS records
   - Confirm Tailscale connectivity

2. **OAuth2 authentication failing**:
   - Verify Google OAuth2 redirect URIs
   - Check OAuth2 proxy logs: `docker logs oauth2-proxy`
   - Confirm cookie secret is properly set

3. **Media services can't connect**:
   - Verify API keys are correctly configured
   - Check internal networking between containers
   - Ensure download paths are properly mapped

### Useful Commands

```bash
# Check service logs
docker logs <container_name>

# Restart specific service
docker compose -f <stack_file> restart <service_name>

# View all running containers
docker ps

# Check Tailscale status
tailscale status

# Test internal connectivity
docker exec -it <container> ping <target>
```

## Security Considerations

1. **Firewall Configuration**:
   - VPS: Allow ports 80, 443, and Tailscale port
   - Home servers: Block external access, only allow Tailscale

2. **Regular Updates**:
   - Watchtower handles container updates automatically
   - Manually update host systems regularly

3. **Backup Strategy**:
   - Backrest handles automated backups
   - Test restore procedures regularly
   - Keep offsite backup of critical configurations

4. **Secret Management**:
   - Never commit `.env` files to version control
   - Rotate API keys and passwords regularly
   - Use strong, unique passwords for all services