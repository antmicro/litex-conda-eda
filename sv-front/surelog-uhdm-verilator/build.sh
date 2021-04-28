#!/bin/bash

set -e
set -x

cd Surelog
make PREFIX=../image release install -j$CPU_COUNT

mkdir -p "$PREFIX/bin"
mkdir -p "$PREFIX/lib/surelog/sv"

cp "$SRC_DIR/image/lib/surelog/sv/builtin.sv" "$PREFIX/lib/surelog/sv/builtin.sv"
cp "$SRC_DIR/image/bin/surelog" "$PREFIX/bin/surelog-uhdm"
