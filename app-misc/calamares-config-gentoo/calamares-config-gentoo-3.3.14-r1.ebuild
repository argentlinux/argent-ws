# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

MY_PN="calamares"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Gentoo Linux ${MY_PN} installer config"
HOMEPAGE="https://gentoo.org"
SRC_URI="https://dev.gentoo.org/~wolf31o2/sources/gentoo-artwork-livecd/gentoo-artwork-livecd-2007.0.tar.bz2
     mirror://gentoo/gentoo-artwork-0.2.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-admin/${MY_PN}"
S="${WORKDIR}"

src_install() {
    dodir "/etc/${MY_PN}"
    insinto "/etc/${MY_PN}"
    doins -r "${FILESDIR}/modules/"
    doins -r "${FILESDIR}/settings.conf"

    insinto /usr/share/applications/
    doins "${FILESDIR}/gentoo-installer.desktop"

    insinto /usr/bin/
    dobin "${FILESDIR}"/${MY_PN}-pkexec

    insinto /etc/calamares/branding/gentoo_branding
    doins -r "${FILESDIR}/artwork/"*
    for i in $(seq 1 10); do
        newins gentoo-livecd-2007.0/800x600.png "${i}.png"
    done
    newins gentoo-artwork-0.2/icons/gentoo/64x64/gentoo.png gentoo.png
    newins gentoo-livecd-2007.0/800x600.png languages.png
}
