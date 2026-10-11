# Copyright 2011-2026 Argent Linux
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Argent Linux nature wallpapers"
HOMEPAGE="https://argentlinux.io"
SRC_URI="http://pkgwork.argentlinux.io/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~arm x86 amd64"

RDEPEND="!<x11-themes/argent-artwork-core-1.5.3-r2"

src_install() {
	insinto /usr/share/backgrounds
	doins -r nature
	dosym -r /usr/share/backgrounds/nature /usr/share/wallpapers/Argent-Nature
}
