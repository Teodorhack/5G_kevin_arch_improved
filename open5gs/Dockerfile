# Imagine de bază
FROM ubuntu:22.04

# Evită prompturile interactive în timpul build-ului
ENV DEBIAN_FRONTEND=noninteractive

# Instalează toate dependențele necesare pentru compilarea Open5GS
RUN apt-get update && apt-get install -y \
    git build-essential meson ninja-build cmake flex bison \
    libsctp-dev libgnutls28-dev libssl-dev libidn11-dev libyaml-dev \
    libmongoc-dev libbson-dev libnghttp2-dev libmicrohttpd-dev \
    libcurl4-openssl-dev libtalloc-dev libmbedtls-dev pkg-config \
    libgcrypt-dev libdw-dev binutils-dev libdwarf-dev \
    python3 python3-pip python3-setuptools python3-wheel python3-yaml \
    iproute2 netbase curl wget && \
    rm -rf /var/lib/apt/lists/*

# Setează directorul sursă
WORKDIR /open5gs-src

# Copiază sursele Open5GS din proiectul local
# (la tine sunt în external/open5gs-src)
COPY ./external/open5gs-src /open5gs-src

# Compilează și instalează Open5GS în /open5gs-src/install
RUN meson build --prefix=/open5gs-src/install && \
    ninja -C build && \
    ninja -C build install

# Copiază scripturile tale de inițializare și pornire
COPY ./scripts/start-open5gs.sh /scripts/start-open5gs.sh
RUN chmod +x /scripts/start-open5gs.sh

# Setează punctul de start al containerului
CMD ["/scripts/start-open5gs.sh"]
