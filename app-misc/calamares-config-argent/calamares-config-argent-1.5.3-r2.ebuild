# Copyright 1999-2015 Gentoo Foundation
# Copyright 2015-2025 Argent Linux developers
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

DESCRIPTION="Argent Linux Calamares modules config"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="installer"

RDEPEND="app-admin/calamares
	x11-themes/argent-artwork-calamares"

S="${FILESDIR}"

src_install() {
	dodir "/etc/calamares" || die
	insinto "/etc/calamares" || die
	doins -r "${S}/"* || die
	insinto "/usr/$(get_libdir)/calamares/modules" || die
	doins -r "${S}/modules/argent_postinstall" || die
}
