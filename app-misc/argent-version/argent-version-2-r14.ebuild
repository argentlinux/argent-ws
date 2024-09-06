# Copyright 2004-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multilib

DESCRIPTION="Argent system release virtual package"
HOMEPAGE="http://www.rogentos.ro"
SRC_URI=""

LICENSE="GPL-2"
SLOT="2.0"
KEYWORDS="amd64 ~arm x86"

IUSE=""
DEPEND=""
GCC_VER="13"
PYTHON_VER="3.11"
BINUTILS_VER="2.42"
RDEPEND="!app-admin/eselect-init
	!sys-apps/hal
	!sys-auth/consolekit
	app-eselect/eselect-python
	sys-apps/gentoo-systemd-integration
	dev-lang/python:${PYTHON_VER}
	sys-apps/systemd
	sys-devel/gcc-config"

src_unpack () {
	echo "Argent Linux ${ARCH} 2.0 " > "${T}/argent-release"
	echo -n "Argent ${ARCH} release 2.0 " > "${T}/system-release"
	mkdir -p "${S}" || die
}

src_prepare(){
	default
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
	gcc-config $(gcc-config -l | grep x86_64-pc-linux-gnu-${GCC_VER} | awk '{print $1}' | awk -F '[][]' '{print $2}')

	eselect profile set "argent-ws:default/linux/amd64/23.0/desktop/systemd"

	# using newest binutils we have available
	export local ARGENT_BINUTILS_CONFIG=$(binutils-config -l | grep "x86_64-pc-linux-gnu-${BINUTILS_VER}" | awk '{print $1}' | awk -F '[][]' '{print $2}' )
	binutils-config "${ARGENT_BINUTILS_CONFIG}"
	ewarn "Please be aware that you should use: source /etc/profile && env-update after this upgrade!"

	# Mandatory Python cleanup
	eselect python cleanup

	# Forcing vboxvideo enable in /etc/default/grub
	sed -i 's/modprobe.blacklist=vboxvideo//g' /etc/default/grub
	if [[ -e "/etc/modprobe.d/blacklist.conf" ]] ; then
		sed -i 's/blacklist vboxvideo//g' /etc/modprobe.d/blacklist.conf
	fi
}
