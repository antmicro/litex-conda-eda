#!/bin/bash

set -e
set -x

which pkg-config

cd yosys

make V=1 -j$CPU_COUNT
make install V=1 -j$CPU_COUNT

pushd $PREFIX/bin

for filename in `ls yosys*`;
do
    mv $filename "antmicro-"$filename
done

popd

$PREFIX/bin/antmicro-yosys -V
