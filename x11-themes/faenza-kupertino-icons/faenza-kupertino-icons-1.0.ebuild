# Copyright 1999-2012 Gentoo Foundation
# Copyright 2012-2015 Rogentos Group
# Copyright 2015-2025 Argent Linux Developers
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"
inherit gnome2-utils xdg

DESCRIPTION="Argent faenza icons"
HOMEPAGE="http://argentlinux.io"
SRC_URI="http://pkgwork.argentlinux.io/distfiles/${CATEGORY}/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm amd64 x86"
IUSE=""

RDEPEND="x11-themes/faenza-icon-theme"

DEPEND=""

DEST="/usr/share/icons"
S="${WORKDIR}"

src_install() {
	insinto ${DEST}
	doins -r "${S}"/Faenza-Kupertino-Light
	doins -r "${S}"/Faenza-Kupertino-Dark
}