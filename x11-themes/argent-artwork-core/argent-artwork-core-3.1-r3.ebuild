# Copyright 2011-2015 Argent Linux
# Distributed under the terms of the GNU General Public License v2
# Maintainer BlackNoxis <stefan.cristian at rogentos.ro>

EAPI=6
inherit eutils mount-boot argent-artwork

DESCRIPTION="Offical Argent-Linux Core Artwork"
HOMEPAGE="http://www.rogentos.ro"
SRC_URI="http://pkgwork.argentlinux.io/distfiles/${CATEGORY}/${PN}/"${PN}"-${PV}.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~arm x86 amd64"
IUSE="plymouth"
RDEPEND="sys-apps/findutils"

S="${WORKDIR}"/"${PN}"

src_install() {
	# Cursors
	insinto /usr/share/cursors/xorg-x11/
	doins -r "${S}"/mouse/RezoBlue
	dosym RezoBlue /usr/share/cursors/xorg-x11/default || "RezoBlue not found"

	# Wallpapers
	insinto /usr/share/backgrounds/
	doins -r "${S}"/background/nature

	# Logos
	insinto /usr/share/pixmaps/
	doins "${S}"/logo/*.png

	# Plymouth theme
	if use plymouth; then
		insinto /usr/share/plymouth
		doins "${S}"/plymouth/bizcom.png
		insinto /usr/share/plymouth/themes
		doins -r "${S}"/plymouth/themes/argent
	fi
}

pkg_postinst() {
	einfo "In order for this to take effect, you must regenerate grub."

	einfo "Please report bugs or glitches to"
	einfo "StefanCristian at gitlab.com/argent/argent-ws"
}
