#!/bin/bash
set -e

echo "===================================="
echo "🚀 Starting srsRAN 5G gNB container"
echo "===================================="

# 🔧 Pornim udev pentru recunoaștere SDR
service udev start || true
udevadm control --reload-rules && udevadm trigger

echo "🔍 Detecting Ettus USRP devices..."
uhd_find_devices || { echo "❌ No USRP device found!"; exit 1; }

echo "🔄 Loading UHD images..."
uhd_usrp_probe || echo "⚠️ Warning: UHD probe failed, continuing..."

# ===============================
# 🛰️ Launch gNB with configuration file
# ===============================
CONFIG_FILE="/config/active_config/srsran/gnb.conf"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Config file not found: $CONFIG_FILE"
  exit 1
fi

echo "⚙️ Starting srsRAN gNB using config: $CONFIG_FILE"

exec srsran_app gnb --config_file "$CONFIG_FILE"
