#!/bin/bash

set -e

echo "⭕️ Starting Open5GS..."

CONFIG_PATH="/config/active_configs/open5gs"
TARGET_PATH="/open5gs-src/install/etc/open5gs"

echo "🔍 Checking for existing Open5GS configuration on the host..."
if [ -d "$CONFIG_PATH" ] && [ "$(ls -A $CONFIG_PATH)" ]; then
    echo "✅ Host configuration folder exists and is not empty. Using host configuration..."
    cp -r "$CONFIG_PATH"/* "$TARGET_PATH"
else
    echo "⚠️ Host configuration folder is missing or empty. Copying container configuration to host..."
    mkdir -p "$CONFIG_PATH"
    cp -r "$TARGET_PATH"/* "$CONFIG_PATH"
    echo "✅ Configuration files copied to host: $CONFIG_PATH"
fi

echo "🚀 Starting Open5GS..."
# Hier kannst du den eigentlichen Startbefehl für Open5GS einfügen
tail -f /dev/null