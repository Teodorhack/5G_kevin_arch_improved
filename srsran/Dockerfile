# ============================================
# srsRAN 5G Standalone (SA) + Ettus B205mini (UHD)
# ============================================

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ======================================================
# 🔧 Install dependencies for UHD + srsRAN 5G + USB
# ======================================================
RUN apt update && apt install -y \
    cmake build-essential git wget curl ninja-build \
    libfftw3-dev libsctp-dev iproute2 iputils-ping \
    libboost-program-options-dev libconfig++-dev \
    libuhd-dev uhd-host libmbedtls-dev libyaml-cpp-dev \
    gnuradio udev sudo usbutils python3 python3-pip && \
    apt clean && rm -rf /var/lib/apt/lists/*

# ======================================================
# 🔌 Download UHD firmware and FPGA images for Ettus
# ======================================================
RUN uhd_images_downloader

# ======================================================
# 🧠 Configure udev for unrestricted USB access
# ======================================================
RUN echo 'SUBSYSTEM=="usb", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/99-usrp.rules

# ======================================================
# ⚙️ Clone and build srsRAN Project (5G Standalone)
# ======================================================
WORKDIR /opt
RUN git clone --depth 1 https://github.com/srsran/srsRAN_Project.git

WORKDIR /opt/srsRAN_Project/build
RUN cmake .. -GNinja
RUN ninja
RUN ninja install
RUN ldconfig

# ======================================================
# 🧾 Copy startup script
# ======================================================
COPY scripts/start-gnb.sh /start-gnb.sh
RUN chmod +x /start-gnb.sh

# ======================================================
# 🔁 Set container startup command
# ======================================================
CMD ["/start-gnb.sh"]
