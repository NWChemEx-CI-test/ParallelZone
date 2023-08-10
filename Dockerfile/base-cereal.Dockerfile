ARG PARENT_IMAGE_NAME

FROM ${PARENT_IMAGE_NAME}:latest

ARG CEREAL_VERSION

# Install cereal
RUN cd /tmp \
    && git clone https://github.com/USCiLab/cereal.git \
    && cd cereal \
    && git checkout tags/v${CEREAL_VERSION} \
    && export BUILD_TARGET=cereal \
    && export FIND_TARGET=cereal \
    && cmake -DJUST_INSTALL_CEREAL=ON -DCMAKE_INSTALL_PREFIX=/install -Bbuild . \
    && cmake --build build \
    && cmake --build build --target install \
    && rm -rf /tmp/cereal
