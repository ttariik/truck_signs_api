# 🐳 Docker Setup Guide - Truck Signs API

**Complete Docker Containerization Guide**

[![Docker](https://img.shields.io/badge/Docker-Containerized-blue.svg?style=flat-square&logo=docker&logoColor=white)](https://docker.com)
[![Production](https://img.shields.io/badge/Production-Ready-brightgreen.svg?style=flat-square)](https://github.com)
[![Multi-Platform](https://img.shields.io/badge/Platform-Multi--Platform-orange.svg?style=flat-square)](https://github.com)

## 📋 Overview

This guide provides comprehensive instructions for containerizing the Truck Signs API using Docker. Whether you're developing locally or deploying to production, this guide covers all scenarios with best practices and security considerations.

---

## 🔧 Prerequisites

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **Docker** | 20.10+ | 24.0+ |
| **Docker Compose** | 2.0+ | 2.20+ |
| **RAM** | 2 GB | 4+ GB |
| **Storage** | 5 GB | 10+ GB |

### Installation

<details>
<summary><strong>🐧 Linux (Ubuntu/Debian)</strong></summary>

```bash
# Update package index
sudo apt update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

</details>

<details>
<summary><strong>🍎 macOS</strong></summary>

```bash
# Install Docker Desktop
# Download from: https://www.docker.com/products/docker-desktop

# Or using Homebrew
brew install --cask docker

# Verify installation
docker --version
docker-compose --version
```

</details>

<details>
<summary><strong>🪟 Windows</strong></summary>

```powershell
# Install Docker Desktop
# Download from: https://www.docker.com/products/docker-desktop

# Or using Chocolatey
choco install docker-desktop

# Verify installation
docker --version
docker-compose --version
```

</details>

---

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/truck-signs-api.git
cd truck-signs-api

# Copy environment template
cp docker.env.example docker.env

# Edit configuration
nano docker.env  # or use your preferred editor
```

### 2. Build and Run

```bash
# Build the Docker image
docker build -t truck-signs-api:latest .

# Run the container
docker run -d \
    --name truck-signs-api \
    -p 8000:8000 \
    --env-file docker.env \
    --restart unless-stopped \
    truck-signs-api:latest

# View logs
docker logs -f truck-signs-api
```

### 3. Access Your Application

- **API Base URL:** http://localhost:8000/truck-signs/
- **Admin Panel:** http://localhost:8000/admin/
- **API Documentation:** http://localhost:8000/truck-signs/products/

---

## ⚙️ Configuration

### Environment Variables

Create and configure your `docker.env` file:

```bash
# === Django Core Settings ===
SECRET_KEY=your-super-secret-key-change-this-in-production
DEBUG=False
DJANGO_SETTINGS_MODULE=truck_signs_designs.settings.docker
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,your-domain.com

# === Database Configuration ===
# Leave empty for SQLite (development)
DB_HOST=
DB_NAME=
DB_USER=
DB_PASSWORD=
DB_PORT=

# For PostgreSQL (production recommended):
# DB_HOST=postgres-server
# DB_NAME=truck_signs_db
# DB_USER=postgres_user
# DB_PASSWORD=secure_password
# DB_PORT=5432

# === Payment Processing (Stripe) ===
STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key
STRIPE_SECRET_KEY=sk_test_your_secret_key

# === Email Configuration ===
EMAIL_HOST_USER=your-email@domain.com
EMAIL_HOST_PASSWORD=your-app-specific-password

# === Media Storage ===
# Local storage (leave empty):
CLOUD_NAME=
CLOUD_API_KEY=
CLOUD_API_SECRET=

# Cloudinary (production recommended):
# CLOUD_NAME=your-cloudinary-name
# CLOUD_API_KEY=your-api-key
# CLOUD_API_SECRET=your-api-secret

# === Security & CORS ===
CORS_ALLOWED_ORIGINS=http://localhost:3000,https://your-frontend-domain.com

# === Admin Configuration ===
CURRENT_ADMIN_DOMAIN=http://localhost:8000
EMAIL_ADMIN=admin@your-domain.com

# === Optional: Auto-create Superuser ===
DJANGO_SUPERUSER_EMAIL=admin@your-domain.com
DJANGO_SUPERUSER_PASSWORD=change-this-secure-password
```

### Configuration Templates

<details>
<summary><strong>🔧 Development Configuration</strong></summary>

```bash
# docker.env.development
SECRET_KEY=dev-secret-key-not-for-production
DEBUG=True
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0

# Use SQLite for development
DB_HOST=
DB_NAME=
DB_USER=
DB_PASSWORD=
DB_PORT=

# Development Stripe keys
STRIPE_PUBLISHABLE_KEY=pk_test_your_test_key
STRIPE_SECRET_KEY=sk_test_your_test_key

# Local file storage
CLOUD_NAME=
CLOUD_API_KEY=
CLOUD_API_SECRET=

# Development admin
DJANGO_SUPERUSER_EMAIL=dev@localhost
DJANGO_SUPERUSER_PASSWORD=devpassword123
```

</details>

<details>
<summary><strong>🚀 Production Configuration</strong></summary>

```bash
# docker.env.production
SECRET_KEY=super-secure-production-key-50-chars-long
DEBUG=False
DJANGO_ALLOWED_HOSTS=your-domain.com,www.your-domain.com

# Production PostgreSQL
DB_HOST=your-postgres-host
DB_NAME=truck_signs_production
DB_USER=truck_signs_user
DB_PASSWORD=very-secure-database-password
DB_PORT=5432

# Production Stripe keys
STRIPE_PUBLISHABLE_KEY=pk_live_your_live_key
STRIPE_SECRET_KEY=sk_live_your_live_key

# Production Cloudinary
CLOUD_NAME=your-production-cloudinary
CLOUD_API_KEY=your-production-api-key
CLOUD_API_SECRET=your-production-api-secret

# Production CORS
CORS_ALLOWED_ORIGINS=https://your-frontend.com,https://www.your-frontend.com

# Production admin
CURRENT_ADMIN_DOMAIN=https://your-domain.com
EMAIL_ADMIN=admin@your-domain.com
```

</details>

---

## 🛠️ Development Workflow

### Local Development Setup

```bash
# Development build with hot reload
docker build -t truck-signs-api:dev .

# Run with volume mounting for development
docker run -d \
    --name truck-signs-api-dev \
    -p 8000:8000 \
    -v $(pwd):/app \
    --env-file docker.env.development \
    --restart unless-stopped \
    truck-signs-api:dev

# Follow logs
docker logs -f truck-signs-api-dev
```

### Development Commands

```bash
# Access container shell
docker exec -it truck-signs-api-dev bash

# Run Django commands
docker exec truck-signs-api-dev python manage.py migrate
docker exec truck-signs-api-dev python manage.py collectstatic --noinput
docker exec truck-signs-api-dev python manage.py createsuperuser

# Run tests
docker exec truck-signs-api-dev python manage.py test

# Django shell
docker exec -it truck-signs-api-dev python manage.py shell
```

### Database Operations

```bash
# Run migrations
docker exec truck-signs-api python manage.py makemigrations
docker exec truck-signs-api python manage.py migrate

# Create superuser interactively
docker exec -it truck-signs-api python manage.py createsuperuser

# Load sample data (if fixtures exist)
docker exec truck-signs-api python manage.py loaddata sample_data.json

# Database shell
docker exec -it truck-signs-api python manage.py dbshell
```

---

## 🏗️ Build Optimization

### Multi-Stage Dockerfile (Advanced)

Create an optimized production Dockerfile:

```dockerfile
# Dockerfile.production
FROM python:3.8-slim as builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Production stage
FROM python:3.8-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Copy Python packages from builder
COPY --from=builder /root/.local /root/.local

# Create app user
RUN useradd --create-home --shell /bin/bash app

# Set up application
WORKDIR /app
COPY --chown=app:app . .
RUN chmod +x entrypoint.sh

# Switch to app user
USER app

# Add local packages to PATH
ENV PATH=/root/.local/bin:$PATH

EXPOSE 8000
ENTRYPOINT ["./entrypoint.sh"]
```

Build production image:

```bash
docker build -f Dockerfile.production -t truck-signs-api:production .
```

### Build Scripts

Create convenient build scripts:

<details>
<summary><strong>📝 build.sh</strong></summary>

```bash
#!/bin/bash
# build.sh

set -e

# Configuration
IMAGE_NAME="truck-signs-api"
VERSION=${1:-latest}
DOCKERFILE=${2:-Dockerfile}

echo "🐳 Building Docker image..."
echo "📦 Image: $IMAGE_NAME:$VERSION"
echo "📄 Dockerfile: $DOCKERFILE"

# Build image
docker build \
    -f "$DOCKERFILE" \
    -t "$IMAGE_NAME:$VERSION" \
    --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
    --build-arg VCS_REF=$(git rev-parse --short HEAD) \
    .

echo "✅ Build completed successfully!"
echo "🚀 Run with: docker run -d --name truck-signs-api -p 8000:8000 --env-file docker.env $IMAGE_NAME:$VERSION"
```

</details>

<details>
<summary><strong>🚀 run.sh</strong></summary>

```bash
#!/bin/bash
# run.sh

set -e

# Configuration
CONTAINER_NAME="truck-signs-api"
IMAGE_NAME="truck-signs-api:latest"
PORT=${1:-8000}
ENV_FILE=${2:-docker.env}

echo "🚀 Starting Truck Signs API..."

# Stop existing container
if docker ps -a --format 'table {{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    echo "🛑 Stopping existing container..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
fi

# Run new container
echo "🐳 Starting new container..."
docker run -d \
    --name "$CONTAINER_NAME" \
    -p "$PORT:8000" \
    --env-file "$ENV_FILE" \
    --restart unless-stopped \
    "$IMAGE_NAME"

echo "✅ Container started successfully!"
echo "🌐 API available at: http://localhost:$PORT/truck-signs/"
echo "👑 Admin panel at: http://localhost:$PORT/admin/"

# Show logs
echo "📋 Container logs:"
docker logs -f "$CONTAINER_NAME"
```

</details>

Make scripts executable:

```bash
chmod +x build.sh run.sh
```

---

## 🔍 Monitoring & Debugging

### Container Health Checks

Add health check to Dockerfile:

```dockerfile
# Add to your Dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/truck-signs/products/ || exit 1
```

### Monitoring Commands

```bash
# Container status
docker ps
docker stats truck-signs-api

# Resource usage
docker exec truck-signs-api top
docker exec truck-signs-api df -h

# Network information
docker port truck-signs-api
docker network ls

# Inspect container
docker inspect truck-signs-api
```

### Log Management

```bash
# View logs
docker logs truck-signs-api

# Follow logs with timestamps
docker logs -f -t truck-signs-api

# Tail last 100 lines
docker logs --tail 100 truck-signs-api

# Filter logs by time
docker logs --since 2024-01-01 truck-signs-api
docker logs --until 2024-01-02 truck-signs-api

# Export logs
docker logs truck-signs-api > app.log 2>&1
```

### Performance Monitoring

Create a monitoring script:

```bash
#!/bin/bash
# monitor.sh

CONTAINER_NAME="truck-signs-api"

while true; do
    clear
    echo "🐳 Docker Container Monitoring - $(date)"
    echo "================================================"
    
    # Container status
    echo "📊 Container Status:"
    docker ps --filter name=$CONTAINER_NAME --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    echo ""
    echo "💾 Resource Usage:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
    
    echo ""
    echo "📋 Recent Logs (last 5 lines):"
    docker logs --tail 5 $CONTAINER_NAME 2>&1
    
    echo ""
    echo "Press Ctrl+C to exit..."
    sleep 10
done
```

---

## 🛡️ Security Best Practices

### Production Security Checklist

- [ ] **Environment Variables**
  - [ ] Use strong, unique `SECRET_KEY`
  - [ ] Set `DEBUG=False`
  - [ ] Configure proper `ALLOWED_HOSTS`
  - [ ] Use environment-specific credentials

- [ ] **Container Security**
  - [ ] Run as non-root user
  - [ ] Use minimal base image
  - [ ] Remove unnecessary packages
  - [ ] Keep images updated

- [ ] **Network Security**
  - [ ] Use HTTPS in production
  - [ ] Configure CORS properly
  - [ ] Implement rate limiting
  - [ ] Use secure headers

- [ ] **Data Protection**
  - [ ] Encrypt database connections
  - [ ] Secure media file storage
  - [ ] Regular backups
  - [ ] Monitor access logs

### Security Configuration

```bash
# docker.env.secure
# Strong secret key (50+ characters)
SECRET_KEY=your-very-long-and-complex-secret-key-here-50-chars-minimum

# Production settings
DEBUG=False
DJANGO_ALLOWED_HOSTS=your-domain.com,www.your-domain.com

# Secure database connection
DB_HOST=secure-postgres-host
DB_NAME=truck_signs_secure
DB_USER=limited_user
DB_PASSWORD=very-complex-password-with-special-chars!@#$

# HTTPS enforcement
SECURE_SSL_REDIRECT=True
SECURE_PROXY_SSL_HEADER=HTTP_X_FORWARDED_PROTO,https

# Security headers
SECURE_BROWSER_XSS_FILTER=True
SECURE_CONTENT_TYPE_NOSNIFF=True
X_FRAME_OPTIONS=DENY

# CORS security
CORS_ALLOWED_ORIGINS=https://your-secure-frontend.com
CORS_ALLOW_CREDENTIALS=True
```

---

## 🔧 Troubleshooting

### Common Issues

<details>
<summary><strong>🚫 Container won't start</strong></summary>

**Problem:** Container exits immediately or fails to start

**Solutions:**
```bash
# Check logs for errors
docker logs truck-signs-api

# Verify environment file
cat docker.env

# Check for port conflicts
netstat -tulpn | grep :8000
# or
lsof -i :8000

# Test with minimal configuration
docker run --rm -it truck-signs-api:latest bash

# Rebuild without cache
docker build --no-cache -t truck-signs-api:latest .
```

</details>

<details>
<summary><strong>🌐 Can't access application</strong></summary>

**Problem:** Application not accessible from browser

**Solutions:**
```bash
# Check container is running
docker ps | grep truck-signs-api

# Verify port mapping
docker port truck-signs-api

# Test from inside container
docker exec truck-signs-api curl http://localhost:8000/truck-signs/products/

# Check firewall settings
sudo ufw status  # Linux
# or check Windows Defender/macOS firewall

# Test with different port
docker run -p 8080:8000 truck-signs-api:latest
```

</details>

<details>
<summary><strong>🗄️ Database connection errors</strong></summary>

**Problem:** Django can't connect to database

**Solutions:**
```bash
# For SQLite (check file permissions)
docker exec truck-signs-api ls -la db.sqlite3

# For PostgreSQL (test connection)
docker exec truck-signs-api pg_isready -h $DB_HOST -p $DB_PORT

# Run migrations manually
docker exec truck-signs-api python manage.py migrate --fake-initial

# Reset database (development only!)
docker exec truck-signs-api rm db.sqlite3
docker exec truck-signs-api python manage.py migrate
```

</details>

<details>
<summary><strong>📁 Static files not loading</strong></summary>

**Problem:** CSS/JS files return 404 errors

**Solutions:**
```bash
# Collect static files
docker exec truck-signs-api python manage.py collectstatic --noinput

# Check static files configuration
docker exec truck-signs-api python manage.py findstatic admin/css/base.css

# Verify WhiteNoise settings
docker exec truck-signs-api python manage.py shell -c "
from django.conf import settings
print('STATIC_URL:', settings.STATIC_URL)
print('STATIC_ROOT:', settings.STATIC_ROOT)
print('STATICFILES_STORAGE:', settings.STATICFILES_STORAGE)
"

# Test static file serving
curl -I http://localhost:8000/static/admin/css/base.css
```

</details>

<details>
<summary><strong>🔑 Permission denied errors</strong></summary>

**Problem:** File permission issues in container

**Solutions:**
```bash
# Check file ownership
docker exec truck-signs-api ls -la

# Fix ownership (if running as root)
docker exec truck-signs-api chown -R app:app /app

# Check Docker daemon permissions
sudo usermod -aG docker $USER
# Then logout and login again

# Use correct user in Dockerfile
USER app
```

</details>

### Debug Mode

Enable debug mode for troubleshooting:

```bash
# Create debug environment
cp docker.env docker.env.debug

# Edit debug configuration
echo "DEBUG=True" >> docker.env.debug
echo "DJANGO_LOG_LEVEL=DEBUG" >> docker.env.debug

# Run with debug configuration
docker run -d \
    --name truck-signs-api-debug \
    -p 8000:8000 \
    --env-file docker.env.debug \
    truck-signs-api:latest

# Monitor debug logs
docker logs -f truck-signs-api-debug
```

---

## 📊 Performance Optimization

### Resource Limits

```bash
# Run with resource constraints
docker run -d \
    --name truck-signs-api \
    --memory=1g \
    --cpus=1.0 \
    --memory-swap=2g \
    -p 8000:8000 \
    --env-file docker.env \
    truck-signs-api:latest
```

### Production Optimizations

```bash
# docker.env.optimized
# Gunicorn workers (2 * CPU cores + 1)
GUNICORN_WORKERS=5
GUNICORN_TIMEOUT=120
GUNICORN_KEEPALIVE=5

# Django optimizations
DJANGO_CONN_MAX_AGE=60
DJANGO_CACHE_BACKEND=redis://redis:6379/1

# Static files optimization
STATICFILES_STORAGE=whitenoise.storage.CompressedManifestStaticFilesStorage
WHITENOISE_USE_FINDERS=False
WHITENOISE_AUTOREFRESH=False
```

---

## 📚 Additional Resources

### Useful Commands Reference

```bash
# === Container Management ===
docker ps                              # List running containers
docker ps -a                           # List all containers
docker stop truck-signs-api            # Stop container
docker start truck-signs-api           # Start container
docker restart truck-signs-api         # Restart container
docker rm truck-signs-api              # Remove container

# === Image Management ===
docker images                          # List images
docker rmi truck-signs-api:latest      # Remove image
docker pull python:3.8-slim           # Pull base image
docker history truck-signs-api:latest # Show image layers

# === Debugging ===
docker exec -it truck-signs-api bash  # Access container shell
docker inspect truck-signs-api        # Detailed container info
docker logs --follow truck-signs-api  # Follow logs
docker stats truck-signs-api          # Resource usage

# === Cleanup ===
docker system prune                   # Remove unused data
docker container prune               # Remove stopped containers
docker image prune                   # Remove unused images
docker volume prune                  # Remove unused volumes
```

### Environment Templates

- **Development:** `docker.env.development`
- **Staging:** `docker.env.staging`  
- **Production:** `docker.env.production`
- **Testing:** `docker.env.testing`

### Related Documentation

- 📚 [Main Documentation](./README.md)
- 🚀 [VPS Deployment Guide](./VPS_DEPLOYMENT.md)
- 🐛 [GitHub Issues](https://github.com/yourusername/truck-signs-api/issues)

---

<div align="center">

**🐳 Happy Containerizing!**

*This guide helps you master Docker deployment for Truck Signs API*

[![Docker](https://img.shields.io/badge/Docker-Mastery-blue.svg?style=flat-square&logo=docker&logoColor=white)](https://docker.com)
[![Production](https://img.shields.io/badge/Production-Optimized-brightgreen.svg?style=flat-square)](https://github.com)

</div>