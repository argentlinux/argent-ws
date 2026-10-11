# Copyright 2011-2026 Argent Linux
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Offical Argent-Linux Core Artwork"
HOMEPAGE="https://argentlinux.io"
SRC_URI="http://pkgwork.argentlinux.io/distfiles/${CATEGORY}/${PN}/${PN}-${PVR}.tar.xz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~arm x86 amd64"
IUSE="branding plymouth"

RDEPEND="plymouth? ( sys-boot/plymouth )"

src_install() {
	insinto /usr/share/pixmaps
	doins logo/*.png

	if use plymouth ; then
		insinto /usr/share/plymouth/themes
		doins -r plymouth/themes/argent
	fi

	if use branding ; then
		insinto /usr/share/plymouth
		doins plymouth/bizcom.png
	fi
}

pkg_postinst() {
	einfo "Please report bugs or glitches to"
	einfo "https://gitlab.com/argent/argent-ws/-/work_items"
}
