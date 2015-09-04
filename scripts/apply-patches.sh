#!/bin/sh

ROOT=$(pwd)
PATCHES=${ROOT}/build/patches

# Patch the kernel
cd ${ROOT}/kernel
git apply ${PATCHES}/kernel/0001-ARM-versatile-EABI-support-for-user-space.patch

# Patch busybox
cd ${ROOT}/packages/busybox
git apply ${PATCHES}/packages/busybox/0001-Add-a-default-config-to-compile-statically.patch
