ARG btag

FROM ghcr.io/nwchemex-ci-test/base_parallelzone:$btag

COPY build_test_release.sh /build_test_release.sh

RUN ["chmod", "+x", "/build_test_release.sh"]

ARG cmake_version
ARG gcc_version
ARG clang_version
ARG ninja_build
ARG use_clang
ARG cmaize_github_token
ARG install
ARG unit_test
ARG int_test

ENV env_cmake_version=$cmake_version
ENV env_gcc_version=$gcc_version
ENV env_clang_version=$clang_version
ENV env_ninja_build=$ninja_build
ENV env_use_clang=$use_clang
ENV env_cmaize_github_token=$cmaize_github_token
ENV env_install=$install
ENV env_unit_test=$unit_test
ENV env_int_test=$int_test

ENTRYPOINT ["/build_test_release.sh"]
