#!/bin/sh -l

CR_PAT=$1
USER=$2
BASE_TAG=$3
CMAKE_VERSION=$4
GCC_VRESION=$5
CLANG_VERSION=$6
NINJA_BUILD=$7
USE_CLANG=$8
CMAIZE_GITHUB_TOKEN=$9
INSTALL=${10}
TEST=${11}
INTEGRATION_TEST=${12}

cd /docker-action

echo $CR_PAT | docker login ghcr.io -u $USER --password-stdin

docker build -t docker-action --build-arg btag=$BASE_TAG --build-arg gcc_version=$GCC_VRESION --build-arg clang_version=$CLANG_VERSION --build-arg ninja_build=$NINJA_BUILD --build-arg use_clang=$USE_CLANG --build-arg cmaize_github_token=$CMAIZE_GITHUB_TOKEN --build-arg install=$INSTALL --build-arg unit_test=$TEST --build-arg int_test=$INTEGRATION_TEST . && docker run docker-action -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker
