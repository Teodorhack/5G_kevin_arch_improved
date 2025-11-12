#!/bin/bash
set -e

OPEN5GS_IMAGE="emt_5gsa_docker-open5gs"
SRSRAN_IMAGE="emt_5gsa_docker-srsran"

CONFIG_PATH="config/active_config/open5gs"

echo "🔨 Checking if Open5GS config directory exists and is not empty..."
if [ -d "$CONFIG_PATH" ] && [ "$(find "$CONFIG_PATH" -mindepth 1 -print -quit 2>/dev/null)" ]; then
    echo "✅ Open5GS config directory exists and is not empty. Skipping extraction."
else
    echo "⚠️ Open5GS config directory is missing or empty. Extracting default config..."
    mkdir -p "$CONFIG_PATH"
    docker run --rm \
        -v "$(pwd)/$CONFIG_PATH:/config" \
        "$OPEN5GS_IMAGE" \
        bash -c "cp -r install/etc/open5gs/* /config"
    echo "✅ Default Open5GS config extracted to $CONFIG_PATH."
fi

# Optional: pentru srsRAN (dacă vrei să extragi și default-ul srsran)
# echo "📦 Extracting srsRAN default config..."
# docker run --rm \
#     -v "$(pwd)/config/active_config/srsran:/config" \
#     "$SRSRAN_IMAGE" \
#     bash -c "cp -r configs/* /config"

echo "✅ Done! Configuration files initialized."
