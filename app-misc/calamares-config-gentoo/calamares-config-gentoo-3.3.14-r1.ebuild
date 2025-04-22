# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

MY_PN="calamares"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Gentoo Linux ${MY_PN} installer config"
HOMEPAGE="https://gentoo.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-admin/${MY_PN}"
S="${WORKDIR}"

src_prepare(){
    default

    # It will always have to read the calamares.desktop 
    # from the original calamares installation
    addread "/usr/share/applications/${MY_PN}.desktop"
    cp "/usr/share/applications/${MY_PN}.desktop" "${S}/${MY_PN}.desktop" || die
    sed -i 's|pkexec ${MY_PN}|${MY_PN}-pkexec|' \
        ${S}/${MY_PN}.desktop || die
    sed -i 's|Name=Install System|Name=Install Gentoo|' \
        ${S}/${MY_PN}.desktop || die
    sed -i 's|Icon=${MY_PN}|Icon=gentoo-logo|' \
        ${S}/${MY_PN}.desktop || die
    sed -i 's|GenericName=System Installer|GenericName=Gentoo Linux|' \
        ${S}/${MY_PN}.desktop || die
    sed -i 's|^Comment=.*|Comment=Gentoo System installer|' \
        ${S}/${MY_PN}.desktop || die
    cp ${S}/${MY_PN}.desktop ${S}/gentoo-installer.desktop || die
}

src_install() {
    dodir "/etc/${MY_PN}"
    insinto "/etc/${MY_PN}"
    doins -r "${FILESDIR}/modules/"
    doins -r "${FILESDIR}/settings.conf"

    insinto /usr/share/applications/
    doins "${S}"/gentoo-installer.desktop

    insinto /usr/bin/
    dobin "${FILESDIR}"/${MY_PN}-pkexec

    insinto /etc/calamares/branding/gentoo_branding
    doins -r "${FILESDIR}/artwork/"*
}