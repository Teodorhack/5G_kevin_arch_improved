#!/bin/bash
set -e

echo "⭕️ Starting Open5GS (improved startup sequence)..."
echo "🔍 Checking configuration..."

# 🧩 1. Update MongoDB URI in configs
echo "🔧 Updating MongoDB URIs in Open5GS configs..."
find /config/active_config/open5gs -type f -name "*.yaml" -exec sed -i 's|mongodb://localhost/open5gs|mongodb://mongodb/open5gs|g' {} \;
echo "✅ MongoDB URIs updated."

# 🧩 2. Copy active configs into container
if [ -d "/config/active_config/open5gs" ]; then
    echo "✅ Using host configuration."
    cp -r /config/active_config/open5gs/* /open5gs-src/install/etc/open5gs/
else
    echo "⚠️ No host configuration found. Using defaults."
fi

cd /open5gs-src/install/bin

# 🧩 3. Start 5GC Core Network Functions
echo "🚀 Starting NRF..."
./open5gs-nrfd &

echo "🚀 Starting SCP..."
./open5gs-scpd &

echo "🚀 Starting UDM..."
./open5gs-udmd &

echo "🚀 Starting UDR..."
./open5gs-udrd &

echo "🚀 Starting AUSF..."
./open5gs-ausfd &

echo "🚀 Starting PCF..."
./open5gs-pcfd &

echo "🚀 Starting NSSF..."
./open5gs-nssfd &

echo "🚀 Starting AMF..."
./open5gs-amfd &

echo "🚀 Starting SMF..."
./open5gs-smfd &

echo "🚀 Starting UPF..."
./open5gs-upfd &

# 🧩 4. Optional — Legacy EPC (4G compatibility)
echo "🚀 Starting HSS..."
./open5gs-hssd &

echo "🚀 Starting MME..."
./open5gs-mmed &

echo "🚀 Starting SGWC/SGWU..."
./open5gs-sgwcd &
./open5gs-sgwud &

# 🧩 5. Wait and monitor logs
echo "✅ All core services launched. Monitoring logs..."

# Dacă logurile nu există încă, creează directorul
mkdir -p /open5gs-src/install/var/log/open5gs
touch /open5gs-src/install/var/log/open5gs/dummy.log

tail -F /open5gs-src/install/var/log/open5gs/*.log
