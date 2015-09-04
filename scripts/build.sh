#!/bin/bash

export ARCH=arm
export SUBRARCH=arm

ROOT=$(pwd)

## Configuring and building the kernel

## Cross compiler for beta metal machine which is more correctly to use
## to compile the kernel/os rather than using arm-linux-gnueabi-.
export CROSS_COMPILE=arm-none-eabi-
KERNEL=kernel
BUILD_OUT_KERNEL=${ROOT}/out/kernel
mkdir -p ${BUILD_OUT_KERNEL}
cd ${ROOT}/${KERNEL}/
# Configure the kernel for versatile machine (ARM9xx)
make O=${BUILD_OUT_KERNEL} versatile_defconfig
# Build the kernel
make O=${BUILD_OUT_KERNEL}


## Change a cross compiler to build user space for Linux
export CROSS_COMPILE=arm-linux-gnueabi-

## Configuring and building busybox

BUSYBOX=packages/busybox
BUILD_OUT_BUSYBOX=${ROOT}/out/${BUSYBOX}
mkdir -p ${BUILD_OUT_BUSYBOX}
cd ${ROOT}/${BUSYBOX}/
# Configure busybox by defconfig
make O=${BUILD_OUT_BUSYBOX} static_defconfig
# Build busybox
make O=${BUILD_OUT_BUSYBOX}
make O=${BUILD_OUT_BUSYBOX} install

## Bulding initramfs

BUILD_FINAL=${ROOT}/out/final

INIT=packages/init
BUILD_FINAL_INITRAMFS=${BUILD_FINAL}/initramfs
mkdir -pv ${BUILD_FINAL_INITRAMFS}/{bin,sbin,etc/init.d,proc,sys,usr/{bin,sbin}}
# Copy busybox to initramfs
cp -av ${BUILD_OUT_BUSYBOX}/_install/* ${BUILD_FINAL_INITRAMFS}
# Copy init.d scripts to initramfs
cp ${ROOT}/build/patches/${BUSYBOX}/etc/init.d/* ${BUILD_FINAL_INITRAMFS}/etc/init.d/
# Create cpio.gz
cd ${BUILD_FINAL_INITRAMFS}
ln -s sbin/init init
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs.cpio.gz

