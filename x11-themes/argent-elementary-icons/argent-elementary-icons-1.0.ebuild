# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Argent elementary icons"
HOMEPAGE="https://github.com/bionel/argent-src"
SRC_URI="http://pkg.rogentos.ro/distfiles/${CATEGORY}/${PN}/${PN}-${PVR}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

DEST="/usr/share/icons"
S="${WORKDIR}/${PN}"

src_install() {
	insinto ${DEST} || die
	doins -r "${S}"/Argent-elementary || die
	doins -r "${S}"/Argent-elementary-dark || die
}
