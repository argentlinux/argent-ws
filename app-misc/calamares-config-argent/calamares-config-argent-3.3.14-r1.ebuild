# Copyright 1999-2015 Gentoo Foundation
# Copyright 2015-2025 Argent Linux
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

MY_PN="calamares"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Argent Linux ${MY_PN} modules config"
HOMEPAGE=""
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-admin/${MY_PN}
        x11-themes/argent-artwork-${MY_PN}"
S="${WORKDIR}/${MY_P}"

src_prepare(){
    default
    sed -i 's|pkexec ${MY_PN}|${MY_PN}-pkexec|' \
        ${MY_PN}.desktop || die
    sed -i 's|Name=Install System|Name=Install Argent|' \
        ${MY_PN}.desktop || die
    sed -i 's|Icon=${MY_PN}|Icon=argent-logo|' \
        ${MY_PN}.desktop || die
    sed -i 's|GenericName=System Installer|GenericName=Argent Linux|' \
        ${MY_PN}.desktop || die
    sed -i 's|^Comment=.*|Comment=Argent System installer|' \
        ${MY_PN}.desktop || die
    mv ${MY_PN}.desktop argent-installer.desktop || die
}

src_install() {
    dodir "/etc/${MY_PN}"
    insinto "/etc/${MY_PN}"
    doins -r "${FILESDIR}/"*

    insinto /usr/share/applications/
    doins "${S}"/argent-installer.desktop

    insinto /usr/bin/
    dobin "${FILESDIR}"/${MY_PN}-pkexec
}

pkg_postinst() {
    if [[ -f "/usr/share/applications/${MY_PN}.desktop" ]]; then
        rm -f "/usr/share/applications/${MY_PN}.desktop" || die
    fi
}