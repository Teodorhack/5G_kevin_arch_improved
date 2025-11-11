#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "⭕️ Starting Open5GS..."

# Define paths used for configuration management
CONFIG_PATH="/config/active_configs/open5gs"
TARGET_PATH="/open5gs-src/install/etc/open5gs"

# 1. Configuration Check and Copy Logic
echo "🔍 Checking for existing Open5GS configuration on the host..."
if [ -d "$CONFIG_PATH" ] && [ "$(ls -A $CONFIG_PATH)" ]; then
    echo "✅ Host configuration folder exists and is not empty. Using host configuration..."
    # Copy configuration files from the host mount point to the installation directory
    cp -r "$CONFIG_PATH"/* "$TARGET_PATH"
else
    echo "⚠️ Host configuration folder is missing or empty. Copying container configuration to host..."
    # Create the host configuration folder and copy the default configs to the host
    mkdir -p "$CONFIG_PATH"
    cp -r "$TARGET_PATH"/* "$CONFIG_PATH"
    echo "✅ Configuration files copied to host: $CONFIG_PATH"
fi

# 2. Start all Open5GS Core Services (The CRITICAL step)
echo "🚀 Starting Open5GS Core Services..."

# Define path to Open5GS compiled binaries
BIN_PATH="/open5gs-src/install/bin"
# Define path to Open5GS log files
LOG_PATH="/open5gs-src/install/var/log/open5gs"

# Start all essential Open5GS components in the background (&). 
# This ensures inter-component dependencies (like AMF connecting to SMF) can be met.
echo "Starting all core services in background..."
$BIN_PATH/open5gs-amfd &
$BIN_PATH/open5gs-smfd &
$BIN_PATH/open5gs-upfd &
$BIN_PATH/open5gs-udmd &
$BIN_PATH/open5gs-hssd &
$BIN_PATH/open5gs-mmed &
$BIN_PATH/open5gs-sgwcd &
$BIN_PATH/open5gs-pgwcd &
$BIN_PATH/open5gs-pcrfd &
$BIN_PATH/open5gs-webui &

echo "✅ All Open5GS core services started."

# 3. Keep the container alive and display logs
# This replaces the empty 'tail -f /dev/null' command and allows real-time debugging.
tail -f $LOG_PATH/*.log