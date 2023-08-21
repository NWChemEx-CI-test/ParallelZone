#!/bin/sh

# Wraps the process for configuring, building, and testing an NWX repo
#
# Usage:
#   build.sh
#
# Other variables:
#   cmake_version: the version of cmake being used in the format x.y.z
#

set -e # Exit with error if any command fails

# checkout repo

git clone https://github.com/NWChemEx-CI-test/ParallelZone.git
cd ParallelZone

cmake_command=cmake
ctest_command=ctest
toolchain_file=$(pwd)/toolchain.cmake


echo "set(BUILD_TESTING ON)" > "${toolchain_file}"
{
  echo "set(CMAKE_CXX_STANDARD 17)"
  echo 'set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)'
  echo "set(BUILD_SHARED_LIBS ON)"
  echo "set(CATCH_ENABLE_COVERAGE ON)"
  echo "set(CMAKE_PREFIX_PATH /install)"
  echo 'set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage -std=c++17")'
  echo 'set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DOMPI_SKIP_MPICXX")'
  echo 'set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --coverage")'
  echo 'set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs")'
  echo 'set(CMAIZE_GITHUB_TOKEN '${env_cmaize_github_token}')'
  echo 'set(CMAKE_BUILD_TYPE Release)'
  echo 'set(ENABLE_SCALAPACK ON)'
  echo 'set(LIBDIR "/usr/lib/x86_64-linux-gnu")'
  echo 'set(BLAS_LIBRARIES   "-L${LIBDIR} -lopenblas")'
  echo 'set(LAPACK_LIBRARIES "-L${LIBDIR} -llapack ${BLAS_LIBRARIES}")'
  echo 'set(ScaLAPACK_LIBRARIES  "-L${LIBDIR} -lscalapack-openmpi ${LAPACK_LIBRARIES}")'
} >> "${toolchain_file}"


# if clang_build is true set clang and 
# clang++ as default c and cxx compiler
# otherwise set gcc as default
# clang and gcc version controlled by defaults
# or inputs
if [ "${env_use_clang}" = true ]
then
    {
      echo "set(CMAKE_C_COMPILER /usr/bin/clang-${env_clang_version})"
      echo "set(CMAKE_CXX_COMPILER /usr/bin/clang++-${env_clang_version})"  
      echo 'set(gpu_backend "none" CACHE STRING "" FORCE)'
    } >> "${toolchain_file}"
else
  {
    echo "set(CMAKE_C_COMPILER /usr/bin/gcc-${env_gcc_version})"
    echo "set(CMAKE_CXX_COMPILER /usr/bin/g++-${env_gcc_version})"  
  } >> "${toolchain_file}"
fi

#Step 2: Configure
if [ "${env_install}" = true ]; then
  export INSTALL_PATH=/install
  if [ "${env_ninja_build}" = true ] ; then
    ${cmake_command} -GNinja -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}" -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH}
  else
    ${cmake_command} -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}" -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH}
  fi
else
  if [ "${env_ninja_build}" = true ] ; then
    ${cmake_command} -GNinja -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}"
  else
    ${cmake_command} -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}"
  fi
fi

#Step 3: Compile
${cmake_command} --build build

# Step 4: test

# set up the envs for running mpiexec in a container
# otherwise tests would fail
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

cd build
# unit testing
if [ "${env_unit_test}" = true ]; then
   echo "Running unit tests..."
   ${ctest_command} -VV -R test_unit*
fi
# integration testing
if [ "${env_int_test}" = true ]; then
  echo "Running integration tests..."
  ${ctest_command} -VV -R test_integration*
fi
cd ..

#Step 5: Install
if [ "${env_install}" = true ]; then
  echo "Installing package..."
  ${cmake_command} --build build --target install
fi

# Step 6: release
cp -r /install ./
if [ "${env_install}" = true ]; then
   echo "Pushing release image..."
   if [ "${env_use_clang}" = true ]; then
      docker build -t ghcr.io/nwchemex-ci-test/release_parallelzone:clang-latest -f Dockerfile/release.Dockerfile .
      docker push ghcr.io/nwchemex-ci-test/release_parallelzone:clang-latest
   else
      docker build -t ghcr.io/nwchemex-ci-test/release_parallelzone:gcc-latest -f Dockerfile/release.Dockerfile .
      docker push ghcr.io/nwchemex-ci-test/release_parallelzone:gcc-latest
   fi
fi