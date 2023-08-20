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
INSTALL=$10

cd /docker-action

echo $CR_PAT | docker login ghcr.io -u $USER --password-stdin

docker build -t docker-action --build-arg btag=$BASE_TAG --build-arg gcc_version=$GCC_VRESION --build-arg clang_version=$CLANG_VERSION ninja_build=$NINJA_BUILD use_clang=$USE_CLANG cmaize_github_token=$CMAIZE_GITHUB_TOKEN install=$INSTALL . && docker run docker-action
