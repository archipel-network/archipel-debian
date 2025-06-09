#!/bin/bash
set -e

CARGO_EXTRA_ARGS="${CARGO_EXTRA_ARGS:-""}"
CARGO_TARGET=${CARGO_TARGET:-$(rustup show | grep Default | cut -d':' -f2 | xargs)}
CARGO_TARGET_DIR="${CARGO_TARGET_DIR:-"."}"
CARGO_MULTIARCH="${CARGO_MULTIARCH:-"none"}"
ARCH_NAME="${ARCH_NAME:-"$(uname -m)"}"
OUT_DIR="${OUT_DIR:-"./target/$ARCH_NAME"}"

mkdir -p "$OUT_DIR"

echo "Build Archipel Core"
make -C ./archipel-core clean
make -C ./archipel-core package-debian
cp -v archipel-core/build/package/debian/archipel-core.deb "$OUT_DIR/archipel-core.deb"
echo ""

echo "Build Bundlecat"
(cd ./bundlecat && cargo clean)
(cd ./bundlecat && cargo deb --multiarch "$CARGO_MULTIARCH" --target $CARGO_TARGET --profile release -- $CARGO_EXTRA_ARGS)
cp -v bundlecat/target/$CARGO_TARGET_DIR/debian/*.deb "$OUT_DIR"
echo ""

echo "Build File Carrier"
(cd ./archipel-file-carrier && cargo clean)
(cd ./archipel-file-carrier && cargo deb --multiarch "$CARGO_MULTIARCH" --target $CARGO_TARGET --profile release -p archipelfc-daemon -- $CARGO_EXTRA_ARGS)
(cd ./archipel-file-carrier && cargo deb --multiarch "$CARGO_MULTIARCH" --target $CARGO_TARGET --profile release -p archipelfc -- $CARGO_EXTRA_ARGS)
cp -v archipel-file-carrier/target/$CARGO_TARGET_DIR/debian/*.deb "$OUT_DIR"
echo ""