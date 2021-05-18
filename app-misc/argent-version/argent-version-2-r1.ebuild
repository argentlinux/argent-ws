# Copyright 2004-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

DESCRIPTION="Argent system release virtual package"
HOMEPAGE="http://www.rogentos.ro"
SRC_URI=""

LICENSE="GPL-2"
SLOT="2.0"
KEYWORDS="amd64 ~arm x86"

IUSE=""
DEPEND=""
GCC_VER="5.4"
PYTHON_VER="3.5"
RDEPEND="!app-admin/eselect-init
	!sys-apps/hal
	!sys-auth/consolekit
	app-eselect/eselect-python
	sys-apps/gentoo-systemd-integration
	dev-lang/python:${PYTHON_VER}
	sys-apps/systemd
	sys-devel/base-gcc:${GCC_VER}
	sys-devel/gcc-config"

src_unpack () {
	echo "Argent Linux ${ARCH} ${PV}" > "${T}/argent-release"
	echo -n "Argent ${ARCH} release ${PV}" > "${T}/system-release"
	mkdir -p "${S}" || die
}

src_prepare(){
	:
}

src_install () {
	insinto /etc
	doins "${T}"/argent-release
	doins "${T}"/system-release

	# reduce the risk of fork bombs
	insinto /etc/security/limits.d
	doins "${FILESDIR}/00-sabayon-anti-fork-bomb.conf"
}

pkg_postinst() {
	# Setup Python ${PYTHON_VER}
	eselect python set python${PYTHON_VER}
	# Setup newest available GCC version
	gcc-config $(gcc-config -l | grep x86_64-pc-linux-gnu-${GCC_VER}.0 | awk '{print $1}' | awk -F '[][]' '{print $2}')
	# No need to set the GCC profile here, since it's done in base-gcc
	
	# Moving to the new-old profiles 13.0
	eselect profile set "argent-ws:default/linux/amd64/13.0"
}
