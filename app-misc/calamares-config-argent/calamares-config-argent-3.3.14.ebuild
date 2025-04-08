# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

MY_P="calamares-${PV}"

DESCRIPTION="Argent Linux Calamares modules config"
HOMEPAGE=""
SRC_URI="https://github.com/calamares/calamares/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-admin/calamares
		x11-themes/argent-artwork-calamares"
S="${WORKDIR}/${MY_P}"

src_prepare(){
	default
	sed -i 's|pkexec calamares|calamares-pkexec|' \
		calamares.desktop || die
	sed -i 's|Name=Install System|Name=Install Argent|' \
		calamares.desktop || die
	sed -i 's|Icon=calamares|Icon=argent-logo|' \
		calamares.desktop || die
	sed -i 's|GenericName=System Installer|GenericName=Argent Linux|' \
		calamares.desktop || die
	sed -i 's|Comment=|Comment=Argent Linux installer|' \
		calamares.desktop || die
	sed -i 's|^Comment=.*|Comment=Argent System installer|' \
		calamares.desktop || die
	mv calamares.desktop argent-installer.desktop || die
}

src_install() {
	dodir "/etc/calamares"
	insinto "/etc/calamares"
	doins -r "${FILESDIR}/"*

	insinto /usr/share/applications/
	doins "${S}"/argent-installer.desktop

	insinto /usr/bin/
	dobin "${FILESDIR}"/calamares-pkexec
}

pkg_postinst() {
	if [[ -f "/usr/share/applications/calamares.desktop" ]]; then
		rm -f "/usr/share/applications/calamares.desktop" || die
	fi
}