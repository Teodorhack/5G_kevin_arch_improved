#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
# The 'set -e' is commented out to allow other services to attempt starting 
# even if one binary fails, providing better debug output in some Docker setups.
# set -e 

echo "⭕️ Starting Open5GS..."

# Define paths used for configuration management
# CRITICAL FIX: The configuration path is adjusted to 'active_config' (singular)
CONFIG_PATH="/config/active_config/open5gs"
TARGET_PATH="/open5gs-src/install/etc/open5gs"

# 1. Configuration Check and Copy Logic
echo "🔍 Checking for existing Open5GS configuration on the host..."
if [ -d "$CONFIG_PATH" ] && [ "$(ls -A $CONFIG_PATH)" ]; then
    echo "✅ Host configuration folder exists and is not empty. Using host configuration..."
    # Copy configuration files from the host mount point to the installation directory
    # -v adds verbosity to see which files are copied
    cp -v "$CONFIG_PATH"/* "$TARGET_PATH"
else
    echo "⚠️ Host configuration folder is missing or empty. Copying container configuration to host..."
    # Create the host configuration folder and copy the default configs to the host
    mkdir -p "$CONFIG_PATH"
    cp -r "$TARGET_PATH"/* "$CONFIG_PATH"
    echo "✅ Configuration files copied to host: $CONFIG_PATH"
fi

# 2. Start all Open5GS Core Services (The CRITICAL step)
echo "🚀 Starting Open5GS Core Services..."

# Define paths (kept for clarity, but full paths are used below)
# BIN_PATH="/open5gs-src/install/bin"
# LOG_PATH="/open5gs-src/install/var/log/open5gs"

echo "Starting all core services in background using full paths..."

# Using the full binary path to bypass any issues with the shell's $PATH 
# and ensure the executables are found, resolving "exited with code 1".

# NRF and SCP must be started first to allow other Network Functions to register
/open5gs-src/install/bin/open5gs-nrf-httpd &
/open5gs-src/install/bin/open5gs-scp-httpd &

# 5G Control Plane Functions
/open5gs-src/install/bin/open5gs-amfd &
/open5gs-src/install/bin/open5gs-smfd &
/open5gs-src/install/bin/open5gs-udmd &
/open5gs-src/install/bin/open5gs-udr-httpd &
/open5gs-src/install/bin/open5gs-ausfd &
/open5gs-src/install/bin/open5gs-pcf-httpd &
/open5gs-src/install/bin/open5gs-bsf-httpd &

# 4G Control Plane Functions (Compatibility)
/open5gs-src/install/bin/open5gs-mmed &
/open5gs-src/install/bin/open5gs-hssd &
/open5gs-src/install/bin/open5gs-sgwcd &
/open5gs-src/install/bin/open5gs-pgwcd &
/open5gs-src/install/bin/open5gs-pcrfd &

# User Plane Function (Data Traffic)
/open5gs-src/install/bin/open5gs-upfd &

# WebUI Interface
/open5gs-src/install/bin/open5gs-webui &

echo "✅ All Open5GS core services started."

# 3. Keep the container alive and display logs
# Using 'exec tail -f' ensures the container remains active and displays real-time logs.
exec tail -f /open5gs-src/install/var/log/open5gs/*.log