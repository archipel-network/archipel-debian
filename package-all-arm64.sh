#!/bin/bash
set -e

export GCC_TOOLCHAIN_PREFIX=aarch64-linux-gnu-
export ARCH=armv8-a
export CARGO_TARGET="aarch64-unknown-linux-gnu"
export CARGO_EXTRA_ARGS="--config target.aarch64-unknown-linux-gnu.linker=\"aarch64-linux-gnu-gcc\""
export CARGO_TARGET_DIR="aarch64-unknown-linux-gnu"
export ARCH_NAME=aarch64
export PKG_ARCH=arm64
export CARGO_MULTIARCH="foreign"

exec ./package-all.sh