FROM ubuntu:20.04
LABEL maintainer="NWChemEx-Project" \
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
		curl \
		coreutils \
	&& apt-get clean \
	&& pip install gcovr \
	&& pip install cppyy \
	&& rm -rf /var/lib/apt/lists/*

ARG CMAKE_VERSION=3.17.0

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /usr/bin/cmake \
      && /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake \
      && rm /tmp/cmake-install.sh

ENV PATH="/usr/bin/cmake/bin:${PATH}"

# install docker
#RUN apt-get install ca-certificates curl gnupg \
#    && install -m 0755 -d /etc/apt/keyrings \
#    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
#    && chmod a+r /etc/apt/keyrings/docker.gpg \
#    && echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
#    && apt-get update \
#    && apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN apt update \
    && apt install apt-transport-https ca-certificates curl software-properties-common -y \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-cache policy docker-ce \
    && apt install docker-ce -y
