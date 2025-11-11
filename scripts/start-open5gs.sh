#!/bin/bash

echo "⭕️ Starting Open5GS (improved startup sequence)..."

CONFIG_PATH="/config/active_config/open5gs"
TARGET_PATH="/open5gs-src/install/etc/open5gs"

# Ensure config files are present
echo "🔍 Checking configuration..."
if [ -d "$CONFIG_PATH" ] && [ "$(ls -A $CONFIG_PATH)" ]; then
    echo "✅ Using host configuration."
    cp -vr "$CONFIG_PATH"/* "$TARGET_PATH"
else
    echo "⚠️ Config missing, copying default configs."
    mkdir -p "$CONFIG_PATH"
    cp -vr "$TARGET_PATH"/* "$CONFIG_PATH"
fi

echo "🚀 Starting NRF..."
/open5gs-src/install/bin/open5gs-nrf-httpd &
sleep 4

echo "🚀 Starting SCP..."
/open5gs-src/install/bin/open5gs-scp-httpd &
sleep 8

echo "🚀 Starting control-plane services..."
/open5gs-src/install/bin/open5gs-amfd &
/open5gs-src/install/bin/open5gs-smfd &
/open5gs-src/install/bin/open5gs-udmd &
/open5gs-src/install/bin/open5gs-udr-httpd &
/open5gs-src/install/bin/open5gs-ausfd &
/open5gs-src/install/bin/open5gs-pcf-httpd &
/open5gs-src/install/bin/open5gs-bsf-httpd &

echo "🚀 Starting EPC compatibility services..."
/open5gs-src/install/bin/open5gs-mmed &
/open5gs-src/install/bin/open5gs-hssd &
/open5gs-src/install/bin/open5gs-sgwcd &
/open5gs-src/install/bin/open5gs-pgwcd &
/open5gs-src/install/bin/open5gs-pcrfd &

echo "🚀 Starting UPF..."
/open5gs-src/install/bin/open5gs-upfd &

echo "🚀 Starting WebUI..."
/open5gs-src/install/bin/open5gs-webui &

echo "✅ All core services launched. Monitoring logs..."
tail -f /open5gs-src/install/var/log/open5gs/*.log
