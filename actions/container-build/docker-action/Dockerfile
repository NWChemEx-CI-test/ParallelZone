ARG btag

FROM ghcr.io/nwchemex-ci-test/base_parallelzone:$btag

COPY build.sh /build.sh

RUN ["chmod", "+x", "/build.sh"]

ARG cmake_version
ARG gcc_version
ARG clang_version
ARG ninja_build
ARG use_clang
ARG cmaize_github_token
ARG install

ENV env_cmake_version=$cmake_version
ENV env_gcc_version=$gcc_version
ENV env_clang_version=$clang_version
ENV env_ninja_build=$ninja_build
ENV env_use_clang=$use_clang
ENV env_cmaize_github_token=$cmaize_github_token
ENV env_install=$install
ENTRYPOINT ["/build.sh"]
