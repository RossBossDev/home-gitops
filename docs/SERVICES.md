# Services Documentation

Detailed documentation for all services in the home server infrastructure.

## Media Automation Services

### Overseerr
**Purpose**: Media request and discovery management  
**URL**: https://overseerr.rossreicks.com  
**Authentication**: Public access  
**Port**: 5055

**Key Features**:
- User-friendly interface for requesting movies and TV shows
- Integration with Plex for library management
- Automatic approval workflows
- User permission management
- Mobile-responsive design

**Configuration**:
- Connect to Plex server at `http://plexvm:32400`
- Add Radarr service: `http://home-server:7878`
- Add Sonarr service: `http://home-server:8989`
- Configure user permissions and quotas

### Radarr
**Purpose**: Movie collection management  
**URL**: https://radarr.rossreicks.com  
**Authentication**: OAuth2 required  
**Port**: 7878

**Key Features**:
- Automated movie downloading and organization
- Quality profile management
- Calendar view of upcoming releases
- Integration with download clients and indexers

**Configuration**:
- Root folder: `/movies`
- Download client: NZBGet (`http://home-server:6789`)
- Indexers: Configured via Prowlarr
- Post-processing: Automatic file organization

### Sonarr
**Purpose**: TV series collection management  
**URL**: https://sonarr.rossreicks.com  
**Authentication**: OAuth2 required  
**Port**: 8989

**Key Features**:
- Automated TV show downloading and organization
- Episode tracking and management
- Season monitoring capabilities
- Series management and metadata

**Configuration**:
- Root folder: `/tv`
- Download client: NZBGet (`http://home-server:6789`)
- Indexers: Configured via Prowlarr
- Series types: Standard, daily, anime

### Prowlarr
**Purpose**: Indexer management for *arr services  
**URL**: https://prowlarr.rossreicks.com  
**Authentication**: OAuth2 required  
**Port**: 9696

**Key Features**:
- Centralized indexer management
- Automatic synchronization with Radarr/Sonarr
- Search capability testing
- Statistics and monitoring

**Configuration**:
- Add usenet and torrent indexers
- Configure API keys for *arr services
- Set up search categories and priorities
- Monitor indexer health and statistics

### NZBGet
**Purpose**: Usenet download client  
**URL**: https://nzb.rossreicks.com  
**Authentication**: OAuth2 required  
**Port**: 6789

**Key Features**:
- High-performance usenet downloading
- Built-in post-processing scripts
- Bandwidth management
- Download queue management

**Configuration**:
- Download directory: `/downloads`
- Configure usenet server settings
- Set up post-processing scripts
- Configure categories for different content types

### Bazarr
**Purpose**: Subtitle management  
**URL**: https://bazarr.rossreicks.com  
**Authentication**: OAuth2 required  
**Port**: 6767

**Key Features**:
- Automatic subtitle downloading
- Multiple subtitle provider support
- Language preference management
- Integration with Radarr and Sonarr

**Configuration**:
- Movie path: `/movies`
- TV show path: `/tv`
- Configure subtitle providers
- Set language preferences and quality settings

### Tautulli
**Purpose**: Plex usage analytics and monitoring  
**URL**: https://tautulli.rossreicks.com  
**Authentication**: Public access  
**Port**: 8181

**Key Features**:
- Detailed Plex usage statistics
- User activity monitoring
- Notification system
- Historical data analysis

**Configuration**:
- Connect to Plex server
- Configure notification agents
- Set up custom scripts for automation
- Define monitoring rules and alerts

### Maintainerr
**Purpose**: Automated media library cleanup  
**URL**: Not directly accessible  
**Authentication**: N/A  
**Port**: 6246

**Key Features**:
- Automated removal of unwatched content
- Configurable retention rules
- Integration with Plex and *arr services
- Detailed logging and reporting

### Plex Recommendations
**Purpose**: AI-powered movie recommendations  
**URL**: Not directly accessible  
**Authentication**: N/A  
**Port**: N/A

**Key Features**:
- OpenAI-powered recommendation engine
- Automatic Plex collection creation
- User viewing history analysis
- Configurable recommendation parameters

**Configuration**:
- Plex URL: `https://plex.rossreicks.com`
- Library: Movies
- Collection: "Recommended Movies"
- History analysis: 30 items
- Recommendations: 20 items

## Infrastructure Services

### OAuth2 Proxy
**Purpose**: Authentication layer for protected services  
**URL**: https://auth.rossreicks.com  
**Authentication**: Google OAuth  
**Port**: 4180

**Key Features**:
- Google OAuth2 integration
- Session management
- Authorization header forwarding
- Email domain restrictions

**Protected Services**:
- Radarr, Sonarr, Prowlarr, Bazarr
- NZBGet, Home Assistant
- Admin interfaces

### Pi-hole
**Purpose**: Network-wide ad blocking and DNS filtering  
**URL**: https://pihole.rossreicks.com  
**Authentication**: Public access  
**Port**: 8080 (web), 53 (DNS)

**Key Features**:
- DNS-based ad blocking
- Custom DNS entries
- Query logging and statistics
- Whitelist/blacklist management

**Configuration**:
- Upstream DNS: Cloudflare (1.1.1.1)
- Block lists: Automatic updates
- Custom DNS entries for local services
- DHCP server (optional)

### Caddy
**Purpose**: Reverse proxy with automatic HTTPS  
**URL**: N/A (proxy for all services)  
**Authentication**: N/A  
**Port**: 80, 443

**Key Features**:
- Automatic Let's Encrypt certificates
- Cloudflare DNS challenge
- HTTP/2 and HTTP/3 support
- Reverse proxy with load balancing

**Configuration**:
- Cloudflare API integration
- OAuth2 proxy integration
- Automatic certificate management
- Custom error pages

### Watchtower
**Purpose**: Automatic container updates  
**URL**: N/A  
**Authentication**: N/A  
**Port**: N/A

**Key Features**:
- Automated container image updates
- Cleanup of old images
- Configurable update schedules
- Notification support

**Configuration**:
- Update interval: 24 hours
- Cleanup enabled
- Monitor all containers
- Graceful container restarts

### Backrest
**Purpose**: Backup management with restic  
**URL**: https://backrest.rossreicks.com  
**Authentication**: Public access  
**Port**: 9898

**Key Features**:
- Web-based backup management
- Restic backend integration
- Scheduled backup jobs
- Restore functionality

**Configuration**:
- Backup targets: Configuration directories
- Repository: Local storage
- Retention policy: Configurable
- Encryption: Built-in

## Database Services

### PostgreSQL
**Purpose**: Primary database server  
**URL**: Internal only  
**Authentication**: Username/password  
**Port**: 5432

**Key Features**:
- Reliable relational database
- ACID compliance
- Backup and recovery
- Performance optimization

**Usage**:
- Activepieces application data
- User management and workflows
- Persistent storage for automations

### Redis
**Purpose**: Caching and message broker  
**URL**: Internal only  
**Authentication**: None  
**Port**: 6379

**Key Features**:
- In-memory data structure store
- High-performance caching
- Message queuing
- Session storage

**Usage**:
- Activepieces job queuing
- Session caching
- Temporary data storage

## Monitoring Services

### Grafana Alloy
**Purpose**: Unified observability agent (replaces Prometheus + cAdvisor)  
**URL**: http://home-server:12345  
**Authentication**: Internal only  
**Port**: 12345

**Key Features**:
- Unified metrics, logs, and traces collection
- Built-in service discovery
- Docker container monitoring
- System metrics collection
- Prometheus-compatible remote write
- Configuration via River language

**Configuration**:
- Config file: `/etc/alloy/config.alloy`
- Collects system metrics (CPU, memory, disk, network)
- Monitors Docker containers and their metrics
- Supports Grafana Cloud or local Grafana endpoints
- Auto-discovers containers with Prometheus annotations

**Monitored Targets**:
- System metrics (replaces node_exporter)
- Container metrics (replaces cAdvisor)
- Docker service discovery
- Custom application metrics

### Grafana
**Purpose**: Metrics visualization and dashboards  
**URL**: https://grafana.rossreicks.com  
**Authentication**: Public access  
**Port**: 3000

**Key Features**:
- Rich dashboard creation
- Multiple data source support
- Alerting and notifications
- User and team management

**Data Sources**:
- Alloy metrics via Prometheus remote write
- Direct connection to Alloy for real-time data
- Custom dashboards for infrastructure monitoring

**Configuration**:
- Default admin password configurable via `GRAFANA_ADMIN_PASSWORD`
- Can connect to Grafana Cloud or use local storage
- Pre-configured for Alloy metrics

## Automation Services

### Activepieces
**Purpose**: Workflow automation platform  
**URL**: https://activepieces.rossreicks.com  
**Authentication**: Public access  
**Port**: 9654

**Key Features**:
- Visual workflow builder
- Extensive integration library
- Webhook support
- Scheduled execution

**Configuration**:
- Database: PostgreSQL
- Cache: Redis
- Frontend URL: https://activepieces.rossreicks.com
- Execution mode: Unsandboxed

### Lunalytics
**Purpose**: Custom analytics platform  
**URL**: http://home-server:2308  
**Authentication**: Internal only  
**Port**: 2308

**Key Features**:
- Custom event tracking
- Analytics dashboard
- Data visualization
- API for custom integrations

## Service Dependencies

### Critical Dependencies
```
OAuth2 Proxy → All protected services
Caddy → External access to all services
Tailscale → Inter-VM communication
PostgreSQL → Activepieces
Redis → Activepieces
Alloy → Grafana (metrics)
```

### Media Stack Dependencies
```
Prowlarr → Radarr, Sonarr (indexers)
NZBGet → Radarr, Sonarr (download client)
Plex → Overseerr, Tautulli, Recommendations
Unpackerr → Radarr, Sonarr (post-processing)
```

## Maintenance and Updates

### Automatic Updates
- **Watchtower**: Updates all containers daily
- **Pi-hole**: Updates block lists automatically
- **Caddy**: Renews certificates automatically

### Manual Maintenance
- **Database backups**: Handled by Backrest
- **Log rotation**: Configured per service
- **Storage cleanup**: Maintainerr for media
- **Security updates**: Host OS updates required

### Monitoring Health
- **Grafana dashboards**: System and service health via Alloy
- **Alloy UI**: Agent health and configuration status
- **Tautulli**: Plex server health and usage
- **Pi-hole**: DNS query statistics and blocking

## Troubleshooting

### Common Issues
1. **Service not accessible**: Check Caddy configuration and Tailscale connectivity
2. **Authentication failures**: Verify OAuth2 proxy configuration and Google settings
3. **Download issues**: Check NZBGet configuration and indexer connectivity
4. **Media not appearing**: Verify Plex library paths and permissions

### Log Locations
- **Docker logs**: `docker logs <container_name>`
- **Service logs**: Usually in `/config/<service>/logs/`
- **System logs**: Host system journal or syslog

### Performance Optimization
- **Resource limits**: Configure Docker resource constraints
- **Storage optimization**: Use appropriate storage backends
- **Network optimization**: Optimize Tailscale and internal routing
- **Database tuning**: PostgreSQL and Redis optimization