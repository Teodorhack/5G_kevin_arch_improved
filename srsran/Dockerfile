# ============================================
# srsRAN 5G Standalone + Ettus B205mini (UHD)
# ============================================
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ----------------------------------------------------------
# 1️⃣  Install prerequisites for UHD, srsRAN 5G, USB, etc.
# ----------------------------------------------------------
RUN apt update && apt install -y \
    cmake build-essential git wget curl ninja-build \
    libfftw3-dev libsctp-dev iproute2 iputils-ping \
    libboost-program-options-dev libconfig++-dev \
    libuhd-dev uhd-host libmbedtls-dev libyaml-cpp-dev \
    gnuradio udev sudo usbutils python3 python3-pip && \
    apt clean && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------
# 2️⃣  Download UHD images (firmware + FPGA)
# ----------------------------------------------------------
RUN uhd_images_downloader

# ----------------------------------------------------------
# 3️⃣  Allow unrestricted USB access to Ettus devices
# ----------------------------------------------------------
RUN echo 'SUBSYSTEM=="usb", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/99-usrp.rules

# ----------------------------------------------------------
# 4️⃣  Clone & build the official srsRAN Project (5G SA)
# ----------------------------------------------------------
WORKDIR /opt
RUN git clone --depth 1 https://github.com/srsran/srsRAN_Project.git

WORKDIR /opt/srsRAN_Project
RUN mkdir build
WORKDIR /opt/srsRAN_Project/build
RUN cmake .. -GNinja
RUN ninja -j$(nproc)
RUN ninja install
RUN ldconfig

# ----------------------------------------------------------
# 5️⃣  Copy startup script
# ----------------------------------------------------------
COPY scripts/start-gnb.sh /start-gnb.sh
RUN chmod +x /start-gnb.sh

# ----------------------------------------------------------
# 6️⃣  Default workdir & startup command
# ----------------------------------------------------------
WORKDIR /
CMD ["/start-gnb.sh"]
