#!/bin/bash
set -e

# === Colors ===
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

LOG_FILE="../logs/5gsa_init.log"
mkdir -p ../logs
exec > >(tee -a "$LOG_FILE") 2>&1

OPEN5GS_IMAGE="emt_5gsa_docker-open5gs"
SRSRAN_IMAGE="emt_5gsa_docker-srsran"

CONFIG_PATH="../config/active_config/open5gs"
SRS_PATH="../config/active_config/srsran"

echo "${BLUE}🔨 Checking Open5GS config directory...${RESET}"
if [ -d "$CONFIG_PATH" ] && [ "$(find "$CONFIG_PATH" -mindepth 1 -print -quit 2>/dev/null)" ]; then
    echo "${GREEN}✅ Open5GS config OK.${RESET}"
else
    echo "${YELLOW}⚠️ Extracting default Open5GS config...${RESET}"
    mkdir -p "$CONFIG_PATH"
    docker run --rm \
        -v "$(pwd)/$CONFIG_PATH:/config" \
        "$OPEN5GS_IMAGE" \
        bash -c "cp -r install/etc/open5gs/* /config"
fi

echo "${YELLOW}📦 Extracting default srsRAN config...${RESET}"
mkdir -p "$SRS_PATH"

docker run --rm \
    -v "$(pwd)/$SRS_PATH:/config" \
    "$SRSRAN_IMAGE" \
    bash -c '
        if [ -d configs ]; then
            cp -r configs/* /config
        elif [ -d install/etc/srsran ]; then
            cp -r install/etc/srsran/* /config
        elif [ -d /etc/srsran ]; then
            cp -r /etc/srsran/* /config
        else
            echo "⚠️ No default config folder found in image!"
        fi
    '

echo "${GREEN}✅ Default srsRAN config extracted (best match found).${RESET}"

yaml