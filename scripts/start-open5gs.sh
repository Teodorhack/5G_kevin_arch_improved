#!/bin/bash
set -e

echo "⭕️ Starting Open5GS (improved startup sequence)..."
echo "🔍 Checking configuration..."

# 🧩 1. Update MongoDB URI in all configs
echo "🔧 Updating MongoDB URIs in Open5GS configs..."
find /config/active_config/open5gs -type f -name "*.yaml" -exec \
    sed -i 's|mongodb://localhost/open5gs|mongodb://mongodb/open5gs|g' {} \;
echo "✅ MongoDB URIs updated."

# 🧩 2. Copy active configs into container
if [ -d "/config/active_config/open5gs" ]; then
    echo "✅ Using host configuration."
    cp -r /config/active_config/open5gs/* /open5gs-src/install/etc/open5gs/
else
    echo "⚠️ No host configuration found. Using defaults."
fi

cd /open5gs-src/install/bin

# 🧩 3. Start Core Network Functions
for svc in nrfd scpd udmd udrd ausfd pcfd nssfd amfd smfd upfd hssd mmed sgwcd sgwud; do
    echo "🚀 Starting $svc..."
    ./open5gs-$svc &
done

# 🧩 4. Logs
mkdir -p /open5gs-src/install/var/log/open5gs
touch /open5gs-src/install/var/log/open5gs/open5gs.log

echo "✅ All core services launched. Monitoring logs..."
tail -F /open5gs-src/install/var/log/open5gs/*.log
