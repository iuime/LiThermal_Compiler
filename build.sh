#!/bin/bash
ROOTPATH=`pwd`
if [ -d $ROOTPATH/LiThermal-Revised ]; then
    echo "Updating..."
    git submodule update --init --recursive
    cd LiThermal-Revised
    git remote set-url origin https://github.com/mcdudu233/LiThermal-Revised.git
    cd ..
else
    echo "Folder not exist, cloning..."
    git clone https://github.com/mcdudu233/LiThermal-Revised.git
fi

export STAGING_DIR=$ROOTPATH/target
mkdir build
cd build
cmake $ROOTPATH/LiThermal-Revised -DROOTPATH=$ROOTPATH -DCMAKE_TOOLCHAIN_FILE=$ROOTPATH/LiThermal-Revised/toolchain.cmake
make -j`nproc`

# compile BSOD
$ROOTPATH/toolchain-sunxi-musl/toolchain/bin/arm-openwrt-linux-gcc -o $ROOTPATH/build/BSOD $ROOTPATH/LiThermal/tools/BSOD.c

# Get all compiled files
if [ ! -d $ROOTPATH/UDISK ]; then
    mkdir $ROOTPATH/UDISK
fi
cp $ROOTPATH/build/LiThermal $ROOTPATH/UDISK
cp $ROOTPATH/build/BSOD $ROOTPATH/UDISK
cp $ROOTPATH/thermalcamera.sh $ROOTPATH/UDISK
