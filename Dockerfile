#
# Copyright (c) 2019 Blue Clover Devices
#
# SPDX-License-Identifier: Apache-2.0
#

FROM buildpack-deps:stretch-scm

LABEL "com.github.actions.name"="ESP32 build"
LABEL "com.github.actions.description"="Build ESP32 ESP-IDF project"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/bcdevices/docker-esp32"
LABEL "homepage"="https://github.com/bcdevices/docker-esp32"
LABEL "maintainer"="Blue Clover Devices"
  
RUN curl -S \
  -L https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz \
  -o /opt/gcc-xtensa.tar.gz \
  && tar zxf /opt/gcc-xtensa.tar.gz -C /opt \
  && rm -f /opt/gcc-xtensa.tar.gz

# hadolint ignore=DL3008
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
	bison \
	bzip2 \
	doxygen \
	flex \
	gcc \
	git \
	gperf \
	libc-dev \
	libc6:i386 \
	libncurses-dev \
	libncurses5:i386 \
	libssl-dev \
	libstdc++6:i386 \
	make \
	p7zip-full \
	python \
	python-cryptography \
	python-future \
	python-pip \
	python-pyparsing \
	python-serial \
	python-setuptools \
	python-wheel \
	wget \
    && apt-get clean && rm -rf /var/lib/apt-lists/*

WORKDIR /usr/src/fw
RUN git clone -b v3.3 --recursive \
  "https://github.com/espressif/esp-idf.git"
RUN python -m pip install -r "/usr/src/fw/esp-idf/requirements.txt"
ENV PATH="/opt/xtensa-esp32-elf/bin:${PATH}"
ENV IDF_PATH="/usr/src/fw/esp-idf"
