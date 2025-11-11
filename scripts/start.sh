#!/bin/bash
set -e

echo "🌅 Starting 5GSA Docker environment..."
echo "--------------------------------------"

# 1️⃣ Ensure Docker service is running
if ! systemctl is-active --quiet docker; then
    echo "🔧 Starting Docker service..."
    sudo systemctl enable docker
    sudo systemctl start docker
else
    echo "✅ Docker service already running."
fi

# 2️⃣ Move to project directory
cd "$(dirname "$0")"/..

# 3️⃣ Check if stack already running
if docker compose ps | grep -q "Up"; then
    echo "⚙️  Stack already running. Skipping start."
else
    echo "🚀 Starting Docker Compose stack..."
    docker compose up -d
fi

# 4️⃣ Wait a bit for containers to stabilize
sleep 5

# 5️⃣ Show active containers
echo "📦 Current running containers:"
docker ps

# 6️⃣ Quick health check of Open5GS
echo "🔍 Checking Open5GS logs..."
docker logs --tail 20 open5gs || echo "⚠️ Open5GS logs not available yet."

echo "✅ Startup complete — all services should be running!"
