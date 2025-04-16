#!/bin/bash
set -e

echo "⭕️ Starting general startup script..."

# echo "[+] Starting MongoDB..."
# mongod --fork --logpath /var/log/mongodb/mongod.log

# echo "[+] Setting up TUN deice with Open5GS netconf.sh..."
# /open5gs-src/misc/netconf.sh

# echo "[+] Starting Open5GS services..."
# /usr/bin/open5gs-mmed -c /etc/open5gs/mme.yaml

echo "✅ Done! Startup Script Done."

