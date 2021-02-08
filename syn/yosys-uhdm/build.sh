#!/bin/bash

set -e
set -x

export PKG_CONFIG_PATH="$BUILD_PREFIX/lib/pkgconfig/"
export CXXFLAGS="$CXXFLAGS -I$BUILD_PREFIX/include"
export LDFLAGS="$CXXFLAGS -L$BUILD_PREFIX/lib -lrt -ltinfo"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$BUILD_PREFIX/lib"

cd Surelog && make PREFIX=$PWD/../image release install -j$CPU_COUNT && cd ..
make CONFIG=conda-linux PROGRAM_PREFIX=uhdm- PREFIX=$PWD/image install -j$CPU_COUNT

mkdir -p "$PREFIX/"

cp -r $SRC_DIR/image/* "$PREFIX/"
