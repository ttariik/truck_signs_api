# 🐳 Docker Setup für Truck Signs API

Dieses Dokument beschreibt, wie du die Truck Signs API mit Docker ausführst.

## 📋 Voraussetzungen

- Docker installiert ([Docker Desktop](https://www.docker.com/products/docker-desktop/))
- Git (zum Klonen des Repositories)

## 🚀 Schnellstart

### 1. Repository klonen
```bash
git clone <repository-url>
cd truck_signs_api-main
```

### 2. Environment-Datei erstellen
```bash
cp docker.env.example docker.env
```

### 3. Environment-Datei anpassen (optional)
Öffne `docker.env` und passe die Werte nach Bedarf an:
```bash
# Für Entwicklung können die Standardwerte verwendet werden
# Für Produktion sollten alle Werte angepasst werden
```

### 4. Docker Image bauen
```bash
./docker-build.sh
```

Oder manuell:
```bash
docker build -t truck-signs-api:latest .
```

### 5. Container starten
```bash
./docker-run.sh
```

Oder manuell:
```bash
docker run -d \
    --name truck-signs-api \
    -p 8000:8000 \
    --env-file docker.env \
    truck-signs-api:latest
```

### 6. Anwendung testen
- **API**: http://localhost:8000/truck-signs/categories/
- **Admin**: http://localhost:8000/admin/
  - Benutzername: `admin`
  - E-Mail: `admin@trucksigns.com` 
  - Passwort: `admin123`

## 📁 Projektstruktur

```
truck_signs_api-main/
├── Dockerfile                 # Docker Image Definition
├── docker-build.sh          # Build Script
├── docker-run.sh            # Run Script
├── docker.env.example       # Environment Template
├── docker.env               # Deine Environment-Datei
├── .dockerignore            # Docker Ignore Datei
├── entrypoint.sh            # Container Startup Script
└── ...
```

## ⚙️ Konfiguration

### Datenbank-Optionen

#### SQLite (Standard - Einfach für Entwicklung)
```bash
# In docker.env
DB_HOST=
```

#### PostgreSQL (Für Produktion)
```bash
# In docker.env
DB_HOST=your-postgres-host
DB_NAME=trucksigns_db
DB_USER=trucksigns_user
DB_PASSWORD=your-secure-password
DB_PORT=5432
```

### Stripe-Integration (Optional)
```bash
# In docker.env
STRIPE_PUBLISHABLE_KEY=pk_test_your_key
STRIPE_SECRET_KEY=sk_test_your_key
```

### E-Mail-Konfiguration (Optional)
```bash
# In docker.env
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
```

## 🔧 Docker Commands

### Container-Management
```bash
# Container stoppen
docker stop truck-signs-api

# Container starten
docker start truck-signs-api

# Container entfernen
docker rm truck-signs-api

# Container-Status anzeigen
docker ps
```

### Logs und Debugging
```bash
# Logs anzeigen
docker logs truck-signs-api

# Logs live verfolgen
docker logs -f truck-signs-api

# In Container einloggen
docker exec -it truck-signs-api bash

# Django Shell im Container
docker exec -it truck-signs-api python manage.py shell
```

### Django Management Commands
```bash
# Superuser erstellen
docker exec -it truck-signs-api python manage.py createsuperuser

# Migrationen ausführen
docker exec -it truck-signs-api python manage.py migrate

# Static files sammeln
docker exec -it truck-signs-api python manage.py collectstatic
```

## 🌐 API-Endpoints

Die API ist unter `http://localhost:8000/truck-signs/` verfügbar:

- `GET /categories/` - Kategorien auflisten
- `GET /products/` - Alle Produkte
- `GET /product-detail/{id}/` - Produktdetails
- `GET /truck-logo-list/` - Truck-Logos
- `POST /order/{id}/create/` - Bestellung erstellen
- `POST /order-payment/{id}/` - Zahlung verarbeiten
- `GET /comments/` - Kommentare
- `POST /comment/create/` - Kommentar erstellen

## 🛠️ Entwicklung

### Image neu bauen nach Änderungen
```bash
docker stop truck-signs-api
docker rm truck-signs-api
docker build -t truck-signs-api:latest .
./docker-run.sh
```

### Daten persistent machen
Für persistente Daten (SQLite-Datenbank), verwende Volumes:
```bash
docker run -d \
    --name truck-signs-api \
    -p 8000:8000 \
    --env-file docker.env \
    -v $(pwd)/data:/app/data \
    truck-signs-api:latest
```

## 🐛 Troubleshooting

### Container startet nicht
```bash
# Logs prüfen
docker logs truck-signs-api

# Häufige Probleme:
# - Falsche Environment-Variablen
# - Port 8000 bereits belegt
# - Unvollständige docker.env Datei
```

### Port-Konflikte
```bash
# Anderen Port verwenden
docker run -d --name truck-signs-api -p 8001:8000 --env-file docker.env truck-signs-api:latest
```

### Datenbank-Probleme
```bash
# Container neu starten mit frischer Datenbank
docker stop truck-signs-api
docker rm truck-signs-api
# SQLite-Datei löschen falls vorhanden
rm -f db.sqlite3
./docker-run.sh
```

### Image-Größe reduzieren
Das aktuelle Image ist für Entwicklung optimiert. Für Produktion:
- Multi-stage Build verwenden
- Alpine Linux als Base Image
- Nur produktionsnotwendige Pakete installieren

## 📊 Performance

### Produktions-Optimierungen
```bash
# Mehr Worker für bessere Performance
docker run -d \
    --name truck-signs-api \
    -p 8000:8000 \
    --env-file docker.env \
    -e GUNICORN_WORKERS=4 \
    truck-signs-api:latest
```

### Monitoring
```bash
# Container-Ressourcen überwachen
docker stats truck-signs-api

# Speicherverbrauch prüfen
docker exec truck-signs-api free -h
```

## 🔒 Sicherheit

### Produktions-Checkliste
- [ ] `DEBUG=False` in docker.env
- [ ] Starkes `SECRET_KEY` generieren
- [ ] Sichere Datenbank-Passwörter
- [ ] HTTPS verwenden (Reverse Proxy)
- [ ] Regelmäßige Updates der Base Images
- [ ] Secrets nicht in Environment-Dateien

### Secrets Management
Für Produktion, verwende Docker Secrets oder externe Secret-Management:
```bash
# Beispiel mit Docker Secrets
echo "my-secret-key" | docker secret create django_secret_key -
```

## 📚 Nützliche Links

- [Docker Documentation](https://docs.docker.com/)
- [Django Deployment](https://docs.djangoproject.com/en/stable/howto/deployment/)
- [Gunicorn Configuration](https://docs.gunicorn.org/en/stable/configure.html)
- [PostgreSQL with Docker](https://hub.docker.com/_/postgres)

## 🆘 Support

Bei Problemen:
1. Prüfe die Container-Logs: `docker logs truck-signs-api`
2. Stelle sicher, dass alle Environment-Variablen korrekt sind
3. Überprüfe, ob Port 8000 verfügbar ist
4. Teste die API-Endpoints mit curl oder einem API-Client

---

**Hinweis**: Diese Docker-Konfiguration ist für Entwicklung und Testing optimiert. Für Produktionsumgebungen sollten zusätzliche Sicherheits- und Performance-Optimierungen vorgenommen werden.
