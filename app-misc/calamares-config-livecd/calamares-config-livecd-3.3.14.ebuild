# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

MY_PN="calamares"
MY_P="${MY_PN}-${PV}"

inherit desktop

DESCRIPTION="Gentoo Linux ${MY_PN} installer config"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~wolf31o2/sources/gentoo-artwork-livecd/gentoo-artwork-livecd-2007.0.tar.bz2
		mirror://gentoo/gentoo-artwork-0.2.tar.bz2"

S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-admin/calamares"

src_install() {
	insinto "/etc/${MY_PN}"
	doins -r "${FILESDIR}/modules/"
	doins -r "${FILESDIR}/settings.conf"

	domenu "${FILESDIR}/gentoo-installer.desktop"

	insinto /usr/bin/
	dobin "${FILESDIR}"/${MY_PN}-pkexec

	insinto /etc/calamares/branding/gentoo_branding
	doins -r "${FILESDIR}/artwork/"*
	for i in {1..10}; do
		newins gentoo-livecd-2007.0/800x600.png "${i}.png"
	done
	newins gentoo-artwork-0.2/icons/gentoo/64x64/gentoo.png gentoo.png
	newins gentoo-livecd-2007.0/800x600.png languages.png
}
