#!/usr/bin/env bash

set -e

# replace DRI libs with symlinks to save space
function slim_down_dri_libs() {
    pushd $STAGING_DIR/usr/lib/dri/

    for f in *.so; do
        if [[ "$f" != "v3d_dri.so" ]]; then
            rm "$f"
            ln -s v3d_dri.so "$f"
        fi
    done

    popd
}


slim_down_dri_libs

# Copy the fwup includes to the images dir
cp -rf $PERIDIO_DEFCONFIG_DIR/fwup_include $BINARIES_DIR

# Create the revert script for manually switching back to the previously
# active firmware.
mkdir -p $TARGET_DIR/usr/share/fwup
$HOST_DIR/usr/bin/fwup -c -f $PERIDIO_DEFCONFIG_DIR/fwup-revert.conf -o $TARGET_DIR/usr/share/fwup/revert.fw
