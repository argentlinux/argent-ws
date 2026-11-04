# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Keeps NVIDIA Maxwell, Pascal and Volta GPUs on the 580 driver branch"
HOMEPAGE="https://argentlinux.io"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="=x11-drivers/nvidia-drivers-580*[-kernel-open]"
