#!/bin/bash

# Docker Run Script for Truck Signs API
set -e

echo "🚀 Starting Truck Signs API Container..."

# Check if docker.env exists
if [ ! -f "docker.env" ]; then
    echo "⚠️  docker.env file not found!"
    echo "📋 Please copy docker.env.example to docker.env and configure your settings:"
    echo "   cp docker.env.example docker.env"
    echo "   # Edit docker.env with your configuration"
    exit 1
fi

# Stop existing container if running
echo "🛑 Stopping existing container (if any)..."
docker stop truck-signs-api 2>/dev/null || true
docker rm truck-signs-api 2>/dev/null || true

# Run the container
echo "▶️  Starting new container..."
docker run -d \
    --name truck-signs-api \
    -p 8000:8000 \
    --env-file docker.env \
    -e DJANGO_SETTINGS_MODULE=truck_signs_designs.settings.docker \
    truck-signs-api:latest

echo "✅ Container started successfully!"
echo "🌐 Application is available at: http://localhost:8000"
echo "🔧 Admin panel: http://localhost:8000/admin/"

# Show container status
echo "📊 Container status:"
docker ps | grep truck-signs-api

echo ""
echo "📋 Useful commands:"
echo "   View logs: docker logs truck-signs-api"
echo "   Follow logs: docker logs -f truck-signs-api"
echo "   Stop container: docker stop truck-signs-api"
echo "   Access shell: docker exec -it truck-signs-api bash"
