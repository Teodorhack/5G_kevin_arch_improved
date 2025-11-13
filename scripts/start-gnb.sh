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
# NOUA CALE DE CONFIGURARE: Reflectă maparea simplificată din docker-compose.yml
CONFIG_FILE="/srsran-config/gnb.ini"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Config file not found: $CONFIG_FILE"
  exit 1
fi

echo "⚙️ Starting srsRAN gNB using config: $CONFIG_FILE"

# -------------------------------------------------------
# Auto-detect which binary is available and launch it
# -------------------------------------------------------
if command -v gnb &> /dev/null; then
  echo "➡️ Using binary: gnb (srsRAN Project 5G)"
  # Flag-ul ini este esențial pentru a evita eroarea YAML
  exec gnb --config-file-type ini -c "$CONFIG_FILE"
elif command -v srsgnb &> /dev/null; then
  echo "➡️ Using binary: srsgnb (legacy)"
  exec srsgnb --config_file "$CONFIG_FILE"
elif command -v srsran_app &> /dev/null; then
  echo "➡️ Using binary: srsran_app"
  # Adaugă flag-ul ini și pentru srsran_app, pentru siguranță
  exec srsran_app gnb --config-file-type ini --config_file "$CONFIG_FILE"
else
  echo "❌ No srsRAN 5G binary found (gnb / srsgnb / srsran_app missing)"
  sleep infinity
fi