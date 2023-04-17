FROM ubuntu:20.04
LABEL maintainer="Yu Zhang <yzhang23@ameslab.gov>" \
      description="Basic building environment for ParallelZone based on the ubuntu 20.04 image."

RUN    apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
		git \
		wget \
		pip \
		gcc \
		g++ \
		clang-11 \
		libc++-11-dev \
		libc++abi-11-dev \
		ninja-build \
		libxml2-dev \
		libxslt-dev \
		python3-dev \
		openmpi-bin \
		libopenmpi-dev \
	&& apt-get clean \
	&& pip install gcovr \
	&& rm -rf /var/lib/apt/lists/*

ARG CMAKE_VERSION=3.17.0

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /usr/bin/cmake \
      && /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake \
      && rm /tmp/cmake-install.sh

ENV PATH="/usr/bin/cmake/bin:${PATH}"



