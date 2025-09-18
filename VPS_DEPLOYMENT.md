# 🚀 VPS Deployment Anleitung - Truck Signs API

## 📋 Überblick
Diese Anleitung zeigt, wie du die Truck Signs API auf deinem VPS (91.99.193.112) auf Port 8020 deployest.

## 🔧 Voraussetzungen auf dem VPS

### 1. Docker Installation prüfen/installieren
```bash
# SSH-Verbindung zum VPS
ssh tsabanovic@91.99.193.112

# Docker installieren (falls nicht vorhanden)
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Neuanmeldung erforderlich nach usermod
exit
ssh tsabanovic@91.99.193.112

# Docker-Installation testen
docker --version
```

## 🚀 Automatisches Deployment

### Option 1: Automatisches Deployment-Script
```bash
# Auf deinem lokalen Mac
cd /Users/tariksabanovic/Desktop/truck_signs_api-main
./deploy-to-vps.sh
```

## 📝 Manuelles Deployment (falls automatisch nicht funktioniert)

### 1. Projekt auf VPS übertragen
```bash
# Auf deinem lokalen Mac - Archiv erstellen
cd /Users/tariksabanovic/Desktop/truck_signs_api-main
tar -czf truck-signs-api.tar.gz \
    --exclude='.git' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='.DS_Store' \
    --exclude='db.sqlite3' \
    --exclude='media/*' \
    --exclude='static/*' \
    --exclude='venv' \
    --exclude='env' \
    .

# Auf VPS hochladen
scp truck-signs-api.tar.gz tsabanovic@91.99.193.112:~/
```

### 2. Auf VPS einloggen und Setup
```bash
# SSH-Verbindung
ssh tsabanovic@91.99.193.112

# Projekt entpacken
tar -xzf truck-signs-api.tar.gz
cd truck_signs_api-main

# Production Environment konfigurieren
cp docker.env.production docker.env

# WICHTIG: Environment-Datei anpassen
nano docker.env
# Ändere mindestens:
# - SECRET_KEY (generiere einen sicheren Schlüssel)
# - DJANGO_SUPERUSER_PASSWORD (sicheres Admin-Passwort)
```

### 3. Docker Image bauen und Container starten
```bash
# Docker Image bauen
docker build -t truck-signs-api:latest .

# Existierende Container stoppen (falls vorhanden)
docker stop truck-signs-api 2>/dev/null || true
docker rm truck-signs-api 2>/dev/null || true

# Container starten auf Port 8020
docker run -d \
    --name truck-signs-api \
    -p 8020:8000 \
    --env-file docker.env \
    --restart unless-stopped \
    truck-signs-api:latest

# Container-Status prüfen
docker ps
docker logs truck-signs-api
```

## 🔒 Sicherheits-Konfiguration

### 1. Firewall konfigurieren
```bash
# UFW installieren und konfigurieren
sudo ufw enable
sudo ufw allow 22    # SSH
sudo ufw allow 8020  # Unsere Anwendung
sudo ufw status
```

### 2. Environment-Variablen sichern
```bash
# Sichere Werte in docker.env setzen
nano docker.env

# Mindestens ändern:
SECRET_KEY=your-super-secure-secret-key-here
DJANGO_SUPERUSER_PASSWORD=your-secure-admin-password
DEBUG=False
```

### 3. Django Secret Key generieren
```python
# Auf dem VPS - Python-Shell öffnen
python3 -c "
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
"
```

## 🌐 Zugriff testen

### URLs:
- **API Base**: http://91.99.193.112:8020/truck-signs/
- **Admin Panel**: http://91.99.193.112:8020/admin/
- **Categories API**: http://91.99.193.112:8020/truck-signs/categories/

### API testen:
```bash
# Vom VPS aus
curl http://localhost:8020/truck-signs/categories/

# Von extern
curl http://91.99.193.112:8020/truck-signs/categories/
```

## 🔧 Container-Management

### Nützliche Docker-Commands:
```bash
# Container-Status
docker ps

# Logs anzeigen
docker logs truck-signs-api
docker logs -f truck-signs-api  # Live-Logs

# Container stoppen/starten
docker stop truck-signs-api
docker start truck-signs-api

# Container neu starten
docker restart truck-signs-api

# In Container einloggen
docker exec -it truck-signs-api bash

# Django-Commands im Container
docker exec -it truck-signs-api python manage.py createsuperuser
docker exec -it truck-signs-api python manage.py migrate
```

## 📊 Monitoring

### System-Ressourcen überwachen:
```bash
# Container-Ressourcen
docker stats truck-signs-api

# System-Ressourcen
htop
df -h
free -h
```

### Logs rotieren:
```bash
# Docker-Log-Rotation konfigurieren
sudo nano /etc/docker/daemon.json
```
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

## 🚨 Troubleshooting

### Container startet nicht:
```bash
# Logs prüfen
docker logs truck-signs-api

# Häufige Probleme:
# - Port 8020 bereits belegt: sudo netstat -tulpn | grep 8020
# - Falsche Environment-Variablen
# - Docker-Daemon nicht gestartet: sudo systemctl start docker
```

### Port-Probleme:
```bash
# Port-Belegung prüfen
sudo netstat -tulpn | grep 8020
sudo lsof -i :8020

# Anderen Port verwenden
docker run -d --name truck-signs-api -p 8021:8000 --env-file docker.env truck-signs-api:latest
```

### Performance-Probleme:
```bash
# Mehr Gunicorn-Worker
docker run -d \
    --name truck-signs-api \
    -p 8020:8000 \
    --env-file docker.env \
    -e GUNICORN_WORKERS=4 \
    truck-signs-api:latest
```

## 🔄 Updates deployen

### Neues Deployment:
```bash
# Container stoppen und entfernen
docker stop truck-signs-api
docker rm truck-signs-api

# Neues Projekt-Archiv hochladen und entpacken
# (Schritte wie oben)

# Image neu bauen
docker build -t truck-signs-api:latest .

# Container neu starten
docker run -d --name truck-signs-api -p 8020:8000 --env-file docker.env --restart unless-stopped truck-signs-api:latest
```

## 📱 Domain-Setup (Optional)

### Nginx Reverse Proxy:
```bash
# Nginx installieren
sudo apt install nginx

# Nginx-Konfiguration
sudo nano /etc/nginx/sites-available/truck-signs-api
```
```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:8020;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
# Site aktivieren
sudo ln -s /etc/nginx/sites-available/truck-signs-api /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 🎯 Nächste Schritte

1. **SSL-Zertifikat** mit Let's Encrypt einrichten
2. **Backup-Strategie** für Datenbank implementieren
3. **Monitoring** mit Prometheus/Grafana
4. **CI/CD Pipeline** für automatische Deployments

---

**🆘 Bei Problemen:**
- Prüfe Container-Logs: `docker logs truck-signs-api`
- Teste API-Endpoints: `curl http://localhost:8020/truck-signs/categories/`
- Überprüfe Firewall: `sudo ufw status`

