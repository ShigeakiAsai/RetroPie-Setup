#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="mesa-drm"
rp_module_desc="libdrm - userspace library for drm"
rp_module_licence="MIT https://www.mesa3d.org/license.html"
rp_module_repo="git https://gitlab.freedesktop.org/mesa/drm libdrm-2.4.114"
rp_module_section="depends"
rp_module_flags=""

function depends_mesa-drm() {
    local depends=(meson ninja-build libgbm-dev libpciaccess-dev)

    getDepends "${depends[@]}"
}

function sources_mesa-drm() {
    gitPullOrClone
}

function build_mesa-drm() {
    local params=()

    # for RPI, disable all but VC4 driver to minimize startup delay
    isPlatform "rpi" && params+=( \
                           -Dintel=false \
                           -Dradeon=false \
                           -Damdgpu=false \
                           -Dexynos=false \
                           -Dnouveau=false \
                           -Dvmwgfx=false \
                           -Domap=false \
                           -Dfreedreno=false \
                           -Dtegra=false \
                           -Detnaviv=false \
                           -Dvc4=true \
                           -Dglx=disabled \
                           -Dplatforms= \
                           -Dllvm=disabled \
                           -Dvulkan-drivers=broadcom \
                           -Ddri-drivers='' \
                           -Dgallium-drivers=v3d,vc4,kmsro \
                           -Dbuildtype=release \
                           )


    meson builddir --prefix="$md_inst" "${params[@]}"
    ninja -C builddir

    md_ret_require="$md_build/builddir/tests/modetest/modetest"
}

function install_mesa-drm() {
    md_ret_files=(
        builddir/libkms/libkms.so*
        builddir/tests/modetest/modetest
    )
}
