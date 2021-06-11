#!/bin/bash

set -e
set -x

export PYTHON_EXECUTABLE=`which python3`

# Prepare python-fpga-interchange dependency
export PYTHON_INTERCHANGE_PATH=`realpath python-fpga-interchange`
pushd $PYTHON_INTERCHANGE_PATH
python3 -m pip install -e .
popd

# Prepare RapidWright dependency
export RAPIDWRIGHT_PATH=`realpath RapidWright`
pushd $RAPIDWRIGHT_PATH
make update_jars
popd

cd nextpnr
mkdir -p build
pushd build
cmake -DARCH=fpga_interchange -DRAPIDWRIGHT_PATH=$RAPIDWRIGHT_PATH -DPYTHON_INTERCHANGE_PATH=$PYTHON_INTERCHANGE_PATH -DCMAKE_INSTALL_PREFIX=${PREFIX} -DPYTHON_EXECUTABLE=$PYTHON_EXECUTABLE ..

make -j${CPU_COUNT}

# List of devices available
DEVICES="xc7a35t \
         xc7z010 \
         xc7a100t \
         xc7a200t"

CHIPDB_DIR=${PREFIX}/share/nextpnr-fpga_interchange/chipdb
DEVICES_DIR=${PREFIX}/share/nextpnr-fpga_interchange/devices
mkdir -p $CHIPDB_DIR
mkdir -p $DEVICES_DIR

# Compute chipdbs for nextpnr-fpga_interchange
for device in $DEVICES; do
	make chipdb-${device}-bin -j${CPU_COUNT}
	cp `find -iname "chipdb-${device}.bin"` $CHIPDB_DIR
	cp `find -name "*.device" | grep -v luts | grep -v constr` $DEVICES_DIR
done

make install

cp bba/bbasm ${PREFIX}/bin
