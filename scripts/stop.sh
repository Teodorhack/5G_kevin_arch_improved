#!/bin/bash
set -e

echo "🌇 Shutting down 5GSA Docker environment..."
cd "$(dirname "$0")"/..

# Oprește containerele în mod curat, dar păstrează volumele și imaginile
docker compose down

# Oprește serviciul Docker doar dacă vrei complet clean
# sudo systemctl stop docker

echo "✅ All containers stopped gracefully."
