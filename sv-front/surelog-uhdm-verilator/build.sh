#!/bin/bash

set -e
set -x

export PKG_CONFIG_PATH="$BUILD_PREFIX/lib/pkgconfig/"
export CXXFLAGS="$CXXFLAGS -I$BUILD_PREFIX/include"
export LDFLAGS="$CXXFLAGS -L$BUILD_PREFIX/lib -lrt -ltinfo"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$BUILD_PREFIX/lib"

cd Surelog
make PREFIX=../image release install -j$CPU_COUNT

mkdir -p "$PREFIX/bin"
mkdir -p "$PREFIX/lib/surelog/sv"

cp "$SRC_DIR/image/lib/surelog/sv/builtin.sv" "$PREFIX/lib/surelog/sv/builtin.sv"
cp "$SRC_DIR/image/bin/surelog" "$PREFIX/bin/surelog-uhdm"
