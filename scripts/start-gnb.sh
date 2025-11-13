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
# SCHIMBĂ CONFIG_FILE PENTRU A FOLOSI YAML (.conf)
CONFIG_FILE="/srsran-config/gnb.yaml"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Config file not found: $CONFIG_FILE"
  exit 1
fi

echo "⚙️ Starting srsRAN gNB using config: $CONFIG_FILE"

# -------------------------------------------------------
# Auto-detect binary and launch with correct syntax
# -------------------------------------------------------
if command -v gnb &> /dev/null; then
  echo "➡️ Using binary: gnb (srsRAN Project 5G) with YAML"
  # Eliminăm flag-ul --config-file-type ini, lăsăm gnb să citească YAML nativ
  exec gnb -c "$CONFIG_FILE" # Lăsăm gnb să citească YAML nativ
elif command -v srsgnb &> /dev/null; then
  echo "➡️ Using binary: srsgnb (legacy) - may fail with YAML"
  # Srsgnb preferă ini, dar încercăm cu config_file
  exec srsgnb --config_file "$CONFIG_FILE"
elif command -v srsran_app &> /dev/null; then
  echo "➡️ Using binary: srsran_app with YAML"
  # Eliminăm flag-ul --config-file-type ini
  exec srsran_app gnb -c "$CONFIG_FILE"
else
  echo "❌ No srsRAN 5G binary found (gnb / srsgnb / srsran_app missing)"
  sleep infinity
fi