# Copyright 1999-2015 Gentoo Foundation
# Copyright 2015-2025 Argent Linux developers
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

inherit xdg

DESCRIPTION="Argent Linux Calamares modules config"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-admin/calamares
	x11-themes/argent-artwork-core
	x11-themes/argent-artwork-calamares"

S="${FILESDIR}"

src_install() {
	dodir "/etc/calamares"
	insinto "/etc/calamares"
	doins -r "${S}/"*
	insinto "/usr/$(get_libdir)/calamares/modules"
	doins -r "${S}/modules/argent_postinstall"

	insinto /usr/bin/
	doins "${S}"/calamares-pkexec

	insinto /usr/share/applications/
	doins "${S}"/argent-installer.desktop
}
