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

> NOTE: By default, the script will try to get Qemu static executable from current chroot architecture.
> But on bookworm and earlier, Qemu executables are not named after system architecture and must be defined manually.
> See "Troubleshooting" section to learn more.

When setup is finished you must be inside your new chroot and ready to build.

```
./package-all.sh
```

Deb packages will be produced into `root/archipel-debian/target` of your chroot

After building all packages required, run `collect-artifacts.sh` to collect all deb packages from all chroots folders into a local `target` folder

### Troubleshooting

#### An error occurred during initial setup and I don't want to start from scratch

Add environment variable `INITIAL_SETUP=true` to trigger apt and rust setup.

```
INITIAL_SETUP=true ./chroot.sh
```

#### `Qemu user executable named "qemu-armhf-static" not found`

Make sure you have installed `qemu-user-static`.
If you are on debian bookworm or earlier you must specify manually appropriate QEMU command to use as `QEMU` environment variable.
Prefer "static" ones.


```
QEMU=qemu-arm-static ./chroot.sh armhf
```