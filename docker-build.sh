#!/bin/bash

# Docker Build Script for Truck Signs API
set -e

echo "🚀 Building Truck Signs API Docker Image..."

# Build the Docker image
docker build -t truck-signs-api:latest .

echo "✅ Docker image built successfully!"
echo "📋 Image name: truck-signs-api:latest"

# Show image info
echo "📊 Image details:"
docker images | grep truck-signs-api

echo ""
echo "🔧 To run the container, use:"
echo "   ./docker-run.sh"
echo ""
echo "Or manually with:"
echo "   docker run -p 8000:8000 --env-file docker.env truck-signs-api:latest"
