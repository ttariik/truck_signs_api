# 🚀 VPS Deployment Guide - Truck Signs API

**Production Deployment Guide for Virtual Private Server**

[![VPS](https://img.shields.io/badge/VPS-Ready-success.svg?style=flat-square)](https://github.com)
[![Production](https://img.shields.io/badge/Production-Tested-brightgreen.svg?style=flat-square)](https://github.com)
[![Docker](https://img.shields.io/badge/Docker-Containerized-blue.svg?style=flat-square&logo=docker&logoColor=white)](https://docker.com)

## 📋 Overview

This comprehensive guide shows you how to professionally deploy the Truck Signs API on any Virtual Private Server (VPS) using Docker containerization. The guide covers both automated and manual deployment methods for production environments.

---

## 🔧 VPS Prerequisites

### 1. Server Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| **CPU** | 1 vCPU | 2+ vCPUs |
| **RAM** | 1 GB | 2+ GB |
| **Storage** | 10 GB | 20+ GB |
| **OS** | Ubuntu 18.04+ | Ubuntu 20.04+ |

### 2. Docker Installation

```bash
# SSH into your VPS
ssh your-username@your-server-ip

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Verify installation
docker --version
docker compose --version
```

### 3. Firewall Configuration

```bash
# Allow SSH (replace 22 with your SSH port if different)
sudo ufw allow 22/tcp

# Allow HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow your application port (e.g., 8020)
sudo ufw allow 8020/tcp

# Enable firewall
sudo ufw --force enable

# Check status
sudo ufw status
```

---

## 🚀 Automated Deployment

### Option 1: One-Command Deployment

Create a deployment script on your local machine:

```bash
#!/bin/bash
# deploy-to-vps.sh

# Configuration - UPDATE THESE VALUES
VPS_IP="your-server-ip"
VPS_USER="your-username"
SSH_KEY="~/.ssh/your-private-key"  # Optional: if using SSH keys
APP_PORT="8020"
CONTAINER_NAME="truck-signs-api"

echo "🚀 Starting deployment to VPS..."

# Create archive
echo "📦 Creating deployment archive..."
tar --exclude='.git' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='.DS_Store' \
    --exclude='db.sqlite3' \
    --exclude='media' \
    --exclude='static' \
    --exclude='*.tar.gz' \
    -czf truck-signs-api.tar.gz .

# Upload to VPS
echo "📤 Uploading to VPS..."
if [ -f "$SSH_KEY" ]; then
    scp -i "$SSH_KEY" truck-signs-api.tar.gz "$VPS_USER@$VPS_IP:~/"
else
    scp truck-signs-api.tar.gz "$VPS_USER@$VPS_IP:~/"
fi

# Deploy on VPS
echo "🐳 Deploying on VPS..."
if [ -f "$SSH_KEY" ]; then
    ssh -i "$SSH_KEY" "$VPS_USER@$VPS_IP" << EOF
else
    ssh "$VPS_USER@$VPS_IP" << EOF
fi
        # Extract archive
        tar -xzf truck-signs-api.tar.gz
        cd truck_signs_api-main

        # Stop existing container
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true

        # Build new image
        docker build -t truck-signs-api:latest .

        # Run container
        docker run -d \\
            --name $CONTAINER_NAME \\
            -p $APP_PORT:8000 \\
            --env-file docker.env \\
            --restart unless-stopped \\
            truck-signs-api:latest

        # Cleanup
        rm -f ~/truck-signs-api.tar.gz

        echo "✅ Deployment completed!"
        echo "🌐 API available at: http://$(curl -s ifconfig.me):$APP_PORT"
EOF

# Cleanup local archive
rm truck-signs-api.tar.gz

echo "🎉 Deployment script completed!"
```

Make it executable and run:

```bash
chmod +x deploy-to-vps.sh
./deploy-to-vps.sh
```

---

## 📝 Manual Deployment

### Step 1: Prepare Project Archive

On your local machine:

```bash
# Navigate to project directory
cd /path/to/truck_signs_api-main

# Create deployment archive
tar --exclude='.git' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='.DS_Store' \
    --exclude='db.sqlite3' \
    --exclude='media' \
    --exclude='static' \
    --exclude='*.tar.gz' \
    -czf truck-signs-api.tar.gz .

# Upload to VPS
scp truck-signs-api.tar.gz your-username@your-server-ip:~/
```

### Step 2: Deploy on VPS

SSH into your VPS and execute:

```bash
# SSH into VPS
ssh your-username@your-server-ip

# Extract project
tar -xzf truck-signs-api.tar.gz
cd truck_signs_api-main

# Configure environment
cp docker.env.example docker.env
nano docker.env  # Edit configuration
```

### Step 3: Configure Environment Variables

Edit the `docker.env` file with your production settings:

```bash
# Django Configuration
SECRET_KEY=your-super-secure-secret-key-here
DEBUG=False
DJANGO_ALLOWED_HOSTS=your-domain.com,your-server-ip,localhost

# Database Configuration (PostgreSQL recommended for production)
DB_HOST=your-postgres-host
DB_NAME=your-database-name
DB_USER=your-database-user
DB_PASSWORD=your-secure-password
DB_PORT=5432

# Payment Processing (Stripe)
STRIPE_PUBLISHABLE_KEY=pk_live_your_publishable_key
STRIPE_SECRET_KEY=sk_live_your_secret_key

# Email Configuration
EMAIL_HOST_USER=your-email@domain.com
EMAIL_HOST_PASSWORD=your-email-app-password

# Media Storage (Cloudinary - recommended for production)
CLOUD_NAME=your-cloudinary-name
CLOUD_API_KEY=your-cloudinary-api-key
CLOUD_API_SECRET=your-cloudinary-secret

# Security & Performance
CORS_ALLOWED_ORIGINS=https://your-frontend-domain.com,https://your-domain.com

# Admin Configuration
CURRENT_ADMIN_DOMAIN=https://your-domain.com
EMAIL_ADMIN=admin@your-domain.com

# Superuser Creation (Optional)
DJANGO_SUPERUSER_EMAIL=admin@your-domain.com
DJANGO_SUPERUSER_PASSWORD=your-admin-password
```

### Step 4: Build and Deploy

```bash
# Build Docker image
docker build -t truck-signs-api:production .

# Stop existing container (if any)
docker stop truck-signs-api 2>/dev/null || true
docker rm truck-signs-api 2>/dev/null || true

# Run production container
docker run -d \
    --name truck-signs-api \
    -p 8020:8000 \
    --env-file docker.env \
    --restart unless-stopped \
    truck-signs-api:production

# Verify deployment
docker ps
docker logs truck-signs-api
```

### Step 5: Verify Installation

```bash
# Check container status
docker ps | grep truck-signs-api

# View logs
docker logs -f truck-signs-api

# Test API endpoint
curl http://localhost:8020/truck-signs/products/

# Check from external network
curl http://your-server-ip:8020/truck-signs/products/
```

---

## 🔒 SSL/HTTPS Setup (Recommended)

### Option 1: Using Nginx Reverse Proxy with Let's Encrypt

```bash
# Install Nginx
sudo apt install nginx

# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Configure Nginx
sudo nano /etc/nginx/sites-available/truck-signs-api
```

Nginx configuration:

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    location / {
        proxy_pass http://localhost:8020;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable and secure:

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/truck-signs-api /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Get SSL certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### Option 2: Using Cloudflare (Recommended)

1. **Set up Cloudflare:**
   - Add your domain to Cloudflare
   - Update nameservers
   - Enable SSL/TLS encryption

2. **Configure DNS:**
   - Add A record: `your-domain.com` → `your-server-ip`
   - Add CNAME: `www` → `your-domain.com`

3. **Update environment:**
   ```bash
   DJANGO_ALLOWED_HOSTS=your-domain.com,www.your-domain.com
   CORS_ALLOWED_ORIGINS=https://your-domain.com,https://www.your-domain.com
   ```

---

## 📊 Production Monitoring

### Health Check Script

Create a monitoring script:

```bash
#!/bin/bash
# health-check.sh

CONTAINER_NAME="truck-signs-api"
API_URL="http://localhost:8020/truck-signs/products/"
LOG_FILE="/var/log/truck-signs-health.log"

# Check container status
if ! docker ps | grep -q $CONTAINER_NAME; then
    echo "$(date): Container $CONTAINER_NAME is not running!" >> $LOG_FILE
    # Restart container
    docker start $CONTAINER_NAME
fi

# Check API response
if ! curl -f -s $API_URL > /dev/null; then
    echo "$(date): API not responding at $API_URL" >> $LOG_FILE
    # Restart container
    docker restart $CONTAINER_NAME
fi

echo "$(date): Health check completed" >> $LOG_FILE
```

Add to crontab:

```bash
crontab -e
# Add: */5 * * * * /path/to/health-check.sh
```

### Log Management

```bash
# View container logs
docker logs truck-signs-api

# Follow logs in real-time
docker logs -f truck-signs-api

# Rotate logs (add to crontab)
docker exec truck-signs-api logrotate -f /etc/logrotate.conf
```

---

## 🔧 Troubleshooting

### Common Issues

<details>
<summary><strong>Container won't start</strong></summary>

```bash
# Check logs
docker logs truck-signs-api

# Check environment file
cat docker.env

# Verify image
docker images | grep truck-signs-api

# Rebuild if necessary
docker build --no-cache -t truck-signs-api:production .
```

</details>

<details>
<summary><strong>Port already in use</strong></summary>

```bash
# Check what's using the port
sudo netstat -tulpn | grep :8020

# Kill process if needed
sudo kill -9 $(sudo lsof -t -i:8020)

# Or use different port
docker run -p 8021:8000 ...
```

</details>

<details>
<summary><strong>Database connection errors</strong></summary>

```bash
# Check database connectivity
docker exec truck-signs-api python manage.py dbshell

# Run migrations manually
docker exec truck-signs-api python manage.py migrate

# Create superuser
docker exec -it truck-signs-api python manage.py createsuperuser
```

</details>

<details>
<summary><strong>Static files not loading</strong></summary>

```bash
# Collect static files
docker exec truck-signs-api python manage.py collectstatic --noinput

# Check WhiteNoise configuration in settings
docker exec truck-signs-api cat truck_signs_designs/settings/docker.py
```

</details>

### Performance Optimization

```bash
# Monitor resource usage
docker stats truck-signs-api

# Optimize container resources
docker run -d \
    --name truck-signs-api \
    --memory=1g \
    --cpus=1.0 \
    -p 8020:8000 \
    --env-file docker.env \
    --restart unless-stopped \
    truck-signs-api:production
```

---

## 📋 Maintenance Tasks

### Regular Updates

```bash
#!/bin/bash
# update-deployment.sh

echo "🔄 Updating Truck Signs API..."

# Backup current container
docker commit truck-signs-api truck-signs-api:backup-$(date +%Y%m%d)

# Pull latest code (if using git)
git pull origin main

# Rebuild image
docker build -t truck-signs-api:latest .

# Rolling update
docker stop truck-signs-api
docker rm truck-signs-api
docker run -d \
    --name truck-signs-api \
    -p 8020:8000 \
    --env-file docker.env \
    --restart unless-stopped \
    truck-signs-api:latest

echo "✅ Update completed!"
```

### Database Backup

```bash
#!/bin/bash
# backup-database.sh

BACKUP_DIR="/backups/truck-signs"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# SQLite backup
docker exec truck-signs-api cp /app/db.sqlite3 /tmp/db_backup.sqlite3
docker cp truck-signs-api:/tmp/db_backup.sqlite3 $BACKUP_DIR/db_$DATE.sqlite3

# PostgreSQL backup (if using PostgreSQL)
# docker exec postgres-container pg_dump -U username dbname > $BACKUP_DIR/db_$DATE.sql

echo "✅ Database backed up to $BACKUP_DIR/db_$DATE.sqlite3"
```

---

## 🌐 Domain Configuration

### DNS Setup

1. **A Record:** Point your domain to your server IP
   ```
   Type: A
   Name: @
   Value: your-server-ip
   TTL: 300
   ```

2. **CNAME Record:** For www subdomain
   ```
   Type: CNAME
   Name: www
   Value: your-domain.com
   TTL: 300
   ```

3. **Update Environment:**
   ```bash
   DJANGO_ALLOWED_HOSTS=your-domain.com,www.your-domain.com,your-server-ip
   CURRENT_ADMIN_DOMAIN=https://your-domain.com
   CORS_ALLOWED_ORIGINS=https://your-domain.com,https://www.your-domain.com
   ```

---

## 📞 Support

If you encounter issues during deployment:

1. **Check the logs:** `docker logs truck-signs-api`
2. **Verify environment:** `docker exec truck-signs-api env`
3. **Test connectivity:** `curl http://your-server-ip:8020/truck-signs/products/`
4. **Review firewall:** `sudo ufw status`

For additional help:
- 📚 [Main Documentation](./README.md)
- 🐳 [Docker Setup Guide](./DOCKER_README.md)
- 🐛 [GitHub Issues](https://github.com/yourusername/truck-signs-api/issues)

---

<div align="center">

**🚀 Happy Deploying!**

*This guide helps you deploy Truck Signs API on any VPS with confidence*

[![VPS](https://img.shields.io/badge/VPS-Production%20Ready-success.svg?style=flat-square)](https://github.com)
[![Docker](https://img.shields.io/badge/Docker-Optimized-blue.svg?style=flat-square&logo=docker&logoColor=white)](https://docker.com)

</div>