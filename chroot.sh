#!/bin/bash

set -e

DEBIAN_DISTRIBUTION="stable"
DEBIAN_ARCHITECTURE="$(dpkg-architecture --query DEB_HOST_ARCH)"
#DEBIAN_ARCHITECTURE="armhf"
BASE_DIRECTORY="./chroot-$DEBIAN_DISTRIBUTION-$DEBIAN_ARCHITECTURE"
QEMU="qemu-$DEBIAN_ARCHITECTURE-static"

INITIAL_SETUP="false"

if [ ! -d "$BASE_DIRECTORY" ]; then
    INITIAL_SETUP="true"
    echo "Installing chroot in $BASE_DIRECTORY";
    mkdir -p "$BASE_DIRECTORY"
    sudo debootstrap --arch "$DEBIAN_ARCHITECTURE" "$DEBIAN_DISTRIBUTION" "$BASE_DIRECTORY"
fi

sudo mount -t proc /proc $BASE_DIRECTORY/proc/
sudo mount --rbind /sys $BASE_DIRECTORY/sys/
sudo mount --rbind /dev $BASE_DIRECTORY/dev/

if [ "$INITIAL_SETUP" == "true" ]; then

    if [ "$QEMU" != "" ]; then
        sudo cp -v $(which $QEMU) $BASE_DIRECTORY/usr/bin
    fi

    # Install Curl, Git, C toolchain and Rust toolchain
    sudo chroot "$BASE_DIRECTORY" $QEMU /bin/bash - <<EOF
apt install git curl build-essential lintian -y
curl https://sh.rustup.rs -sSf | sh -s -- -y
. "/root/.cargo/env"
cargo install cargo-deb
mkdir -p /root/.cargo/git/
EOF


fi

sudo rsync -av --exclude='chroot-*' --exclude='target' . $BASE_DIRECTORY/root/archipel-debian/

sudo mount -t tmpfs none $BASE_DIRECTORY/root/.cargo/git/ # Required as a workaround for 
# a bug in cargo described here https://github.com/rust-lang/cargo/issues/8719
# present when building for armhf

exec sudo chroot "$BASE_DIRECTORY" $QEMU /bin/bash -c 'cd /root/archipel-debian/ && exec bash'