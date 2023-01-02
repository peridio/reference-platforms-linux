# Build instructions for CI

## Tagged releases

In this example we will build the `rpi4` target

```bash
export TARGET=rpi4
export VERSION=$(cat VERSION)
```

- Build the initramfs by reading the INITRAMFS_ARCH file in the target directory

```bash
export INITRAMFS_ARCH=$(cat targets/$TARGET/INITRAMFS_ARCH)
./tools/scripts/create-build.sh o/initramfs-${INITRAMFS_ARCH} initramfs/${INITRAMFS_ARCH}_defconfig
cd o/initramfs-${INITRAMFS_ARCH}
make
```

Next build the target system

```bash
./tools/scripts/create-build.sh o/$TARGET targets/$TARGET/defconfig tools/buildroot-external-peridio-platform/configs/peridio_platform_defconfig
cd o/$TARGET
make
```

Finally compress the `images` directory from the output to create the artifact

```bash
tar cJ -C o/$TARGET -f peridio-reference-platform-$TARGET-$VERSION.xz images --transform "s/images/peridio-reference-platform-$TARGET-$VERSION/"
```
