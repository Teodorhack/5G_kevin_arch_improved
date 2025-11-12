# ============================================
# srsRAN 5G + Ettus B205mini-i (UHD) — Plug & Play
# ============================================
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 🔧 Instalăm tot ce e necesar pentru UHD + srsRAN + USB + debugging
RUN apt update && apt install -y \
    cmake build-essential git wget curl \
    libfftw3-dev libsctp-dev iproute2 iputils-ping \
    libboost-program-options-dev libconfig++-dev \
    libuhd-dev uhd-host libmbedtls-dev libyaml-cpp-dev \
    gnuradio udev sudo usbutils \
    libdw-dev binutils-dev libdwarf-dev && apt clean

# 🔌 Descărcare automată imagini UHD pentru Ettus (FPGA + firmware)
RUN uhd_images_downloader

# 🧠 Configurăm udev pentru acces la USB fără restricții (în container)
RUN echo 'SUBSYSTEM=="usb", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/99-usrp.rules

# 🔁 Activăm udev service în container
RUN apt install -y systemd udev && systemctl enable systemd-udevd.service || true

# ⚙️ Copiem sursa srsRAN (va fi montată extern sau preinclusă)
COPY external/srsran-src /srsran-src
WORKDIR /srsran-src

# 🏗️ Build srsRAN din sursă
RUN mkdir build && cd build && \
    cmake .. -DCMAKE_VERBOSE_MAKEFILE=ON && \
    make -j$(nproc) && make install && ldconfig

# 🧾 Copiem scriptul de pornire
COPY scripts/start-gnb.sh /start-gnb.sh
RUN chmod +x /start-gnb.sh

# 🔁 Executăm la pornire
CMD ["/start-gnb.sh"]
