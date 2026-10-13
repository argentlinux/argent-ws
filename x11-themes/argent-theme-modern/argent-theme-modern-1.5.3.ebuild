# Copyright 2026 Argent Linux Developers
# Author: Darius Crisan <dariuscrisan37@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Argent Modern theme for KDE Plasma 6 and GTK"
HOMEPAGE="https://argentlinux.io"
SRC_URI="http://pkgwork.argentlinux.io/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"

LICENSE="GPL-3+ GPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	kde-plasma/aurorae:6
	kde-plasma/breeze:6
	x11-themes/argent-papirus-icon-theme
"
