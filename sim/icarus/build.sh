#! /bin/bash

set -e
set -x

CPU_COUNT=$(nproc)

export CC_FOR_BUILD=$CC

sh ./autoconf.sh
./configure --prefix=$PREFIX

make -j$CPU_COUNT
make install

$PREFIX/bin/iverilog -V
$PREFIX/bin/iverilog -h || true
