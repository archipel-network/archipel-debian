# Archipel Packages for Debian

Set of scripts to build debian packages of Archipel core and utilities in one place on multiple architecture.

## Build packages

On any debian system, clone this repository with recusrive submodule initialization

```
git clone https://github.com/archipel-network/archipel-debian.git --recurse-submodules
```

Make sure to have basic chroot utilities and administrator right on your machine.

```
sudo apt install debootstrap rsync qemu-user-static
```

Build and start a chroot

```
./chroot.sh
```

When setup is finished you must be inside your new chroot and ready to build.

```
./package-all.sh
```

Deb packages will be produced into `root/archipel-debian/target` of your chroot