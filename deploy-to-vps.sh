#!/bin/bash

# Deployment Script für VPS
set -e

VPS_IP="91.99.193.112"
VPS_USER="tsabanovic"
PROJECT_NAME="truck-signs-api"
PORT="8020"

echo "🚀 Deploying Truck Signs API to VPS..."

# 1. Projekt-Archiv erstellen
echo "📦 Creating project archive..."
tar -czf ${PROJECT_NAME}.tar.gz \
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

echo "✅ Archive created: ${PROJECT_NAME}.tar.gz"

# 2. Auf VPS hochladen
echo "📤 Uploading to VPS..."
scp ${PROJECT_NAME}.tar.gz ${VPS_USER}@${VPS_IP}:~/

# 3. Deployment-Commands für VPS
echo "🔧 Creating deployment commands..."
cat > deploy_commands.sh << 'EOF'
#!/bin/bash
set -e

PROJECT_NAME="truck-signs-api"
PORT="8020"

echo "🔧 Setting up project on VPS..."

# Stoppe existierende Container
docker stop $PROJECT_NAME 2>/dev/null || true
docker rm $PROJECT_NAME 2>/dev/null || true

# Entpacke Projekt
rm -rf $PROJECT_NAME
tar -xzf ${PROJECT_NAME}.tar.gz
mv truck_signs_api-main $PROJECT_NAME || mv . $PROJECT_NAME 2>/dev/null || true
cd $PROJECT_NAME

# Kopiere Production Environment
cp docker.env.production docker.env

# Baue Docker Image
echo "🏗️  Building Docker image..."
docker build -t $PROJECT_NAME:latest .

# Starte Container auf Port 8020
echo "🚀 Starting container on port $PORT..."
docker run -d \
    --name $PROJECT_NAME \
    -p $PORT:8000 \
    --env-file docker.env \
    --restart unless-stopped \
    $PROJECT_NAME:latest

echo "✅ Deployment completed!"
echo "🌐 Application available at: http://91.99.193.112:$PORT"
echo "🔧 Admin panel: http://91.99.193.112:$PORT/admin/"

# Container-Status anzeigen
docker ps | grep $PROJECT_NAME
EOF

# 4. Deployment-Script auf VPS hochladen
scp deploy_commands.sh ${VPS_USER}@${VPS_IP}:~/

# 5. Auf VPS ausführen
echo "🚀 Executing deployment on VPS..."
ssh ${VPS_USER}@${VPS_IP} "chmod +x deploy_commands.sh && ./deploy_commands.sh"

# 6. Aufräumen
rm ${PROJECT_NAME}.tar.gz deploy_commands.sh

echo ""
echo "🎉 Deployment completed successfully!"
echo "🌐 Your application is now running at: http://91.99.193.112:8020"
echo "🔧 Admin panel: http://91.99.193.112:8020/admin/"
echo ""
echo "📋 Useful commands for VPS management:"
echo "  ssh ${VPS_USER}@${VPS_IP}"
echo "  docker logs $PROJECT_NAME"
echo "  docker exec -it $PROJECT_NAME bash"

