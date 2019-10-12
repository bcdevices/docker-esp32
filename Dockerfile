#
# Confidential!!!
# Source code property of Blue Clover Design LLC.
#
# Demonstration, distribution, replication, or other use of the
# source codes is NOT permitted without prior written consent
# from Blue Clover Design.
#

FROM buildpack-deps:stretch-scm

LABEL "com.github.actions.name"="ESP32 build"
LABEL "com.github.actions.description"="Build ESP32 ESP-IDF project"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/bcdevices/docker-esp32"
LABEL "homepage"="https://github.com/bcdevices/docker-es32"
LABEL "maintainer"="Blue Clover Devices"
  
RUN curl -S \
  -L https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz \
  -o /opt/gcc-xtensa.tar.gz \
  && tar zxf /opt/gcc-xtensa.tar.gz -C /opt \
  && rm -f /opt/gcc-xtensa.tar.gz

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
	python-pip \
	python-serial \
	python-setuptools \
	python-wheel \
	wget \
    && rm -rf /var/lib/apt-lists/*

WORKDIR /usr/src/fw

RUN git clone -b v3.3 --recursive \
  "https://github.com/espressif/esp-idf.git"
RUN python -m pip install --user -r "/usr/src/fw/esp-idf/requirements.txt"

# Copy everything (use .dockerignore to exclude)
COPY . /usr/src/fw/

ENV PATH="/opt/xtensa-esp32-elf/bin:${PATH}"
ENV IDF_PATH="/usr/src/fw/esp-idf"

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
