# Copyright 2004-2013 Sabayon Linux
# Copyright 2004-2014 Argent, Argent and ArgOS Linux
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit versionator

K_ROGKERNEL_NAME="argent"
K_ROGKERNEL_URI_CONFIG="yes"
K_ROGKERNEL_SELF_TARBALL_NAME="argent"
K_ONLY_SOURCES="1"
K_ROGKERNEL_FORCE_SUBLEVEL="77"
K_KERNEL_NEW_VERSIONING="1"

inherit argent-kernel

KEYWORDS="amd64 ~arm x86"
DESCRIPTION="Official Argent Linux Standard kernel sources"
RESTRICT="mirror"
IUSE="sources_standalone"

DEPEND="${DEPEND}
	sources_standalone? ( !=sys-kernel/linux-argent-${PVR} )
	!sources_standalone? ( =sys-kernel/linux-argent-${PVR} )"
