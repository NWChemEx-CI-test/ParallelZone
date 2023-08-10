ARG PARENT_IMAGE_NAME

FROM ${PARENT_IMAGE_NAME}:latest

ARG SPDLOG_VERSION

# Install spdlog
RUN cd /tmp \
    && git clone https://github.com/gabime/spdlog.git \
    && cd spdlog \
    && git checkout ${SPDLOG_VERSION} \
    && export BUILD_TARGET=spdlog \
    && export FIND_TARGET=spdlog::spdlog \
    && cmake -DSPDLOG_INSTALL=ON -DCMAKE_INSTALL_PREFIX=/install -DCMAKE_CXX_FLAGS="-fPIC" -Bbuild . \
    && cmake --build build \
    && cmake --build build --target install \
    && rm -rf /tmp/spdlog
