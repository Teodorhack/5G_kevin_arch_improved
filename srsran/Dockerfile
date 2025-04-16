FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    cmake \
    build-essential \
    libfftw3-dev \
    libsctp-dev \
    iproute2 \
    iputils-ping \
    libboost-program-options-dev \
    libconfig++-dev \
    libuhd-dev \
    uhd-host \
    libmbedtls-dev \
    libgtest-dev \
    libyaml-cpp-dev \
    gnuradio && apt clean

RUN apt update && apt install -y \
    libdw-dev \
    binutils-dev \
    libdwarf-dev

ENV CMAKE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu

COPY external/srsran-src /srsran-src
WORKDIR /srsran-src

RUN mkdir build && cd build && \
    cmake .. -DCMAKE_VERBOSE_MAKEFILE=ON && make -j $(nproc) && \
    make install && \
    ldconfig

COPY scripts/start-gnb.sh /start-gnb.sh
RUN chmod +x /start-gnb.sh

CMD ["/start-gnb.sh"]

