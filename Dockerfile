FROM debian:stable-slim

RUN apt-get update && \
    apt-get -y --no-install-recommends install make binutils upx-ucl wget gcc-arm-linux-gnueabihf software-properties-common && \
    add-apt-repository "deb http://httpredir.debian.org/debian sid main" && \
    apt-get update && \
    apt-get -t sid install -y --no-install-recommends golang-1.17-go && \
    apt clean && \
    rm -rf /var/lib/apt && \
    rm -rf /var/lib/dpkg

RUN wget https://github.com/tinygo-org/tinygo/releases/download/v0.21.0/tinygo_0.21.0_amd64.deb \
    && dpkg -i tinygo_0.21.0_amd64.deb \
    && rm tinygo_0.21.0_amd64.deb

ENV PATH="/usr/lib/go-1.17/bin/:$PATH"
