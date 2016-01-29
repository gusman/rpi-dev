#!/bin/sh

export RPI_ENV_TOP_DIR=`pwd`
TOOL_DIR=$RPI_ENV_TOP_DIR/tools
DOC_DIR=$RPI_ENV_TOP_DIR/documentation
FW_DIR=$RPI_ENV_TOP_DIR/firmware
UBOOT_DIR=$RPI_ENV_TOP_DIR/u-boot-arm
export KERN_DIR=$RPI_ENV_TOP_DIR/linux
export BR_DIR=$RPI_ENV_TOP_DIR/buildroot

BUILD_DIR=$RPI_ENV_TOP_DIR/build
export BR_ROOTFS_OVERLAY_DIR=$BUILD_DIR/configs/buildroot/rootfs-overlay
export BR_PRE_IMAGE_SCRIPT=$BUILD_DIR/configs/buildroot/pre-image-script.sh

DIR_TOOLCHAIN=$TOOL_DIR/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi
export PATH=$PATH:$DIR_TOOLCHAIN/bin

# kernel compile options
export BUILD_TARGET_ARCH=arm
export BUILD_TARGET_CC=arm-bcm2708hardfp-linux-gnueabi-

if [ ! -d $BR_DIR ]; then
    echo "[ $BR_DIR is not exist ]"
    echo ">> Clone buildroot"
    git clone -v --progress git://git.busybox.net/buildroot
fi

if [ ! -d $DOC_DIR ]; then
    echo "[ $DOC_DIR is not exist ]"
    echo ">> Clone raspberry-pi documentation"
    git clone -v --progress https://github.com/raspberrypi/documentation
fi

if [ ! -d $FW_DIR ]; then
    echo "[ $FW_DIR is not exist ]"
    echo ">> Clone raspberry-pi firmware"
    git clone -v --progress https://github.com/raspberrypi/firmware
fi

if [ ! -d $KERN_DIR ]; then
    echo "[ $KERN_DIR is not exist ]"
    echo ">> Clone raspberry-pi kernel"
    git clone -v --progress https://github.com/raspberrypi/linux
fi

if [ ! -d $TOOL_DIR ]; then
    echo "[ $TOOL_DIR is not exist ]"
    echo ">> Clone raspberry-pi development tools"
    git clone -v --progress https://github.com/raspberrypi/tools
fi

if [ ! -d $UBOOT_DIR ]; then
    echo "[ $UBOOT_DIR is not exist ]"
    echo ">> Clone uboot for arm"
    git clone -v --progress git://git.denx.de/u-boot-arm.git
fi

