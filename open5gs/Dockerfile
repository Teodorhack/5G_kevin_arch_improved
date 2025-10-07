FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Add MongoDB official repo
RUN apt update && apt install -y wget gnupg curl && \
    curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg && \
    echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] http://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list

RUN apt update && apt install -y \
    git \
    pkg-config \
    cmake \
    build-essential \
    meson \
    ninja-build \
    libmnl-dev \
    libyaml-dev \
    libmicrohttpd-dev \
    libcurl4-gnutls-dev \
    libgnutls28-dev \
    libtalloc-dev \
    # mongodb-org \
    # mongodb-org-shell \
    mongodb-mongosh \
    libmongoc-dev \
    curl \
    wget \
    python3 \
    python3-pip \
    libgcrypt-dev \
    libidn11-dev \
    libnghttp2-dev \
    libsctp-dev \
    libmbedtls-dev \
    flex \
    bison \
    libdw-dev \
    binutils-dev \
    libdwarf-dev \
    iproute2 && \
    apt clean

ENV CMAKE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu

COPY external/open5gs-src /open5gs-src
WORKDIR /open5gs-src

RUN meson build --prefix=/open5gs-src/install && \
    ninja -C build && cd build && \
    ninja install

COPY scripts/init_configs.sh /scripts/init_configs.sh
RUN chmod +x /scripts/init_configs.sh

######
# RUN /scripts/init_configs.sh

COPY scripts/start-open5gs.sh /start-open5gs.sh
RUN chmod +x /start-open5gs.sh

CMD ["/start-open5gs.sh"]