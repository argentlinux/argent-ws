# Copyright 2008-2014 Sabayon Linux
# Copyright 2014-2021 Argent, Argent and ArgOS Linux
# Distributed under the terms of the GNU General Public License v2
EAPI="7"

inherit ver_*

K_ARGENT_FORCE_SUBLEVEL="$( get_version_component_range 3)"
K_ROGKERNEL_NAME="server"
K_ROGKERNEL_URI_CONFIG="yes"
K_ROGKERNEL_SELF_TARBALL_NAME="server"
K_ONLY_SOURCES="1"
K_ROGKERNEL_FORCE_SUBLEVEL="${ARGENT_FORCE_SUBLEVEL}"
K_KERNEL_NEW_VERSIONING="1"

inherit argent-kernel

KEYWORDS="amd64 ~arm x86"
DESCRIPTION="Official Argent Linux Standard kernel sources"
RESTRICT="mirror"
IUSE="sources_standalone"

DEPEND="${DEPEND}
	sources_standalone? ( !=sys-kernel/linux-server-${PVR} )
	!sources_standalone? ( =sys-kernel/linux-server-${PVR} )"
