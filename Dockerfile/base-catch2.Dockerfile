ARG PARENT_IMAGE_NAME

FROM ${PARENT_IMAGE_NAME}:latest

ARG CATCH2_VERSION

# Install catch2 ##
RUN cd /tmp \
    && git clone -b v${CATCH2_VERSION} https://github.com/catchorg/Catch2.git \
    && cd Catch2 \
    && cmake -Bbuild -H. -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=/install \
    && cmake --build build \
    && cmake --build build --target install \
    && rm -rf /tmp/Catch2
