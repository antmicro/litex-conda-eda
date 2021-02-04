#!/bin/bash

set -e
set -x

export PKG_CONFIG_PATH="$BUILD_PREFIX/lib/pkgconfig/"
export CXXFLAGS="$CXXFLAGS -I$BUILD_PREFIX/include"

cd Surelog && make LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$BUILD_PREFIX/lib" LDFLAGS="$CXXFLAGS -L$BUILD_PREFIX/lib -lrt -ltinfo" CONFIG=gcc CC=gcc-${USE_SYSTEM_GCC_VERSION} CXX=g++-${USE_SYSTEM_GCC_VERSION} PREFIX=$PWD/../image release install -j$CPU_COUNT && cd ..
make LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$BUILD_PREFIX/lib" LDFLAGS="$CXXFLAGS -L$BUILD_PREFIX/lib -lrt -ltinfo" CONFIG=gcc CC=gcc-${USE_SYSTEM_GCC_VERSION} CXX=g++-${USE_SYSTEM_GCC_VERSION} PROGRAM_PREFIX=uhdm- PREFIX=$PWD/image install -j$CPU_COUNT

mkdir -p "$PREFIX"

cp -r "$SRC_DIR"/image/* "$PREFIX/"
