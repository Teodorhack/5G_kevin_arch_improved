# ============================================
# 🧱 Dockerfile — Build and Run Open5GS Core
# ============================================

FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 🔧 Install all required build tools and libraries
RUN apt-get update && apt-get install -y \
    git build-essential meson ninja-build cmake flex bison \
    libsctp-dev libgnutls28-dev libssl-dev libidn11-dev libyaml-dev \
    libmongoc-dev libbson-dev libnghttp2-dev libmicrohttpd-dev \
    libcurl4-openssl-dev libtalloc-dev libmbedtls-dev pkg-config \
    libgcrypt-dev libdw-dev binutils-dev libdwarf-dev \
    python3 python3-pip python3-setuptools python3-wheel python3-yaml \
    iproute2 netbase curl wget iputils-ping netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /open5gs-src

# 📦 Copy Open5GS source from local directory
COPY ./external/open5gs-src /open5gs-src

# 🏗️ Build and install Open5GS
RUN meson build --prefix=/open5gs-src/install && \
    ninja -C build && \
    ninja -C build install

# 🧩 Copy startup script and make it executable
COPY ./scripts/start-open5gs.sh /scripts/start-open5gs.sh
RUN chmod +x /scripts/start-open5gs.sh

# 🚀 Default entrypoint
CMD ["/scripts/start-open5gs.sh"]
