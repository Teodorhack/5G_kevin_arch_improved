#!/bin/bash

set -e

OPEN5GS_IMAGE="emt_5gsa_docker-open5gs"
SRSRAN_IMAGE="emt_5gsa_docker-srsran"

echo "[+] Creating config directory if not exists..."
mkdir -p config/open5gs config/srsran

echo "📦 Extracting Open5GS default config..."
docker run --rm \
    -v "$(pwd)/config/open5gs:/config" \
    "$OPEN5GS_IMAGE" \
    bash -c "cp -r configs/* /config"

echo "📦 Extracting srsRAN default config..."
docker run --rm \
    -v "$(pwd)/config/srsran:/config" \
    "$SRSRAN_IMAGE" \
    bash -c "cp -r configs/* /config"

echo "✅ Done! Configs are now in ./config/open5gs and ./config/srsran."