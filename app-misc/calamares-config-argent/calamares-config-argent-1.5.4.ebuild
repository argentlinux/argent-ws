# Copyright 1999-2015 Gentoo Foundation
# Copyright 2015-2026 Argent Linux developers
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Argent Linux Calamares modules config"
HOMEPAGE="https://argentlinux.io"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=app-admin/calamares-3.4.2
	x11-themes/argent-artwork-calamares"

S="${FILESDIR}"

src_install() {
	insinto /etc/calamares
	doins settings.conf

	insinto /etc/calamares/modules
	doins modules/*.conf

	insinto /usr/$(get_libdir)/calamares/modules
	doins -r modules/argent_postinstall

	dobin calamares-pkexec
	domenu argent-installer.desktop
}
