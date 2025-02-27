# Copyright 1999-2015 Gentoo Foundation
# Copyright 2015-2025 Rogentos Group
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="8"

inherit git-r3

DESCRIPTION="Versatile Advanced Script for ISO and Latest Enchantments"
HOMEPAGE="http://rogentos.ro"

EGIT_BRANCH="argent"
EGIT_REPO_URI="https://gitlab.com/argent/avasile.git"

LICENSE="GPL-2"
SLOT="0/2.4"
KEYWORDS="amd64"
IUSE="server"

DEPEND="
	sys-fs/squashfs-tools
	sys-boot/grub:2
	dev-libs/libisoburn
	sys-fs/mtools"
RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe "${S}"/"${PN}"
	dodir /lib64/"${PN}"
	insinto /lib64/"${PN}"
	doins "${S}/libavasile"
}
