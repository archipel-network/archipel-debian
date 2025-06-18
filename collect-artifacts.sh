#!/bin/bash

set -e

USER=$(whoami)

for chroot in $(ls | grep chroot-); do
    echo "Collecting artifacts for $chroot"
    sudo rsync -rv --chown=$USER:$USER "$chroot/root/archipel-debian/target/" ./target
    echo ""
    echo ""
done