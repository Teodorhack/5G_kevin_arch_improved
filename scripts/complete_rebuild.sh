#!/bin/bash
set -e
echo "🚀 Rebuilding and starting Open5GS stack..."
docker compose down -v
docker system prune -f
docker compose build --no-cache
docker compose up -d
echo "✅ Stack started successfully!"
docker ps
docker logs -f open5gs