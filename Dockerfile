FROM ubuntu:20.04
ARG SRC_DIR='.'
WORKDIR /ParalleZone
ADD ${SRC_DIR}/install /ParalleZone
