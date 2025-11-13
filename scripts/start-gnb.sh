#!/bin/bash
set -e

echo "===================================="
echo "🚀 Starting srsRAN 5G gNB container"
echo "===================================="

# -------------------------------------------------------
# Start udev service to detect Ettus USRP inside container
# -------------------------------------------------------
service udev start || true
udevadm control --reload-rules && udevadm trigger

# -------------------------------------------------------
# Detect Ettus USRP hardware
# -------------------------------------------------------
echo "🔍 Detecting Ettus USRP devices..."
uhd_find_devices || { echo "❌ No USRP device found!"; exit 1; }

# -------------------------------------------------------
# Load UHD firmware and FPGA image
# -------------------------------------------------------
echo "🔄 Loading UHD images..."
uhd_usrp_probe || echo "⚠️ Warning: UHD probe failed, continuing..."

# -------------------------------------------------------
# Launch the srsRAN 5G gNB with config file
# -------------------------------------------------------
CONFIG_FILE="/config/active_config/srsran/gnb.ini"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Config file not found: $CONFIG_FILE"
  exit 1
fi

echo "⚙️ Starting srsRAN gNB using config: $CONFIG_FILE"

# -------------------------------------------------------
# Auto-detect which binary is available and launch it
# -------------------------------------------------------
# -------------------------------------------------------
# Auto-detect binary and launch with correct syntax
# -------------------------------------------------------
# -------------------------------------------------------
# Auto-detect binary and launch with correct syntax
# -------------------------------------------------------
# -------------------------------------------------------
# Auto-detect binary and launch with correct syntax
# -------------------------------------------------------
if command -v gnb &> /dev/null; then
  echo "➡️ Using binary: gnb (srsRAN Project 5G)"
  exec gnb -c "$CONFIG_FILE"
elif command -v srsgnb &> /dev/null; then
  echo "➡️ Using binary: srsgnb (legacy)"
  exec srsgnb --config_file "$CONFIG_FILE"
elif command -v srsran_app &> /dev/null; then
  echo "➡️ Using binary: srsran_app"
  exec srsran_app gnb --config_file "$CONFIG_FILE"
else
  echo "❌ No srsRAN 5G binary found (gnb / srsgnb / srsran_app missing)"
  sleep infinity
fi
