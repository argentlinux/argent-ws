# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
EGIT_REPO_URI="https://gitlab.com/argent/argent-skel.git"

inherit eutils git-2 fdo-mime

DESCRIPTION="Argent Linux skel tree"
HOMEPAGE="http://www.rogentos.ro/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""
DEPEND=""
RDEPEND="
	x11-themes/argent-theme
	x11-themes/numix-icon-theme
	x11-themes/numix-icon-theme-circle
	x11-themes/argent-artwork-community
	x11-themes/argent-artwork-core"

src_install () {
	dodir /etc/xdg/menus
	cp "${S}"/* "${D}"/etc/ -Ra
	chown root:root "${D}"/etc/skel -R

	dodir /usr/share/desktop-directories
	cp "${FILESDIR}"/3.0/xdg/*.directory "${D}"/usr/share/desktop-directories/
	dodir /usr/share/argent
	cp -a "${FILESDIR}"/3.0/* "${D}"/usr/share/argent/
	doicon "${FILESDIR}"/3.0/img/argent-weblink.png
}

pkg_postinst() {
	if [ -x "/usr/bin/xdg-desktop-menu" ]; then
		xdg-desktop-menu install \
			/usr/share/argent/xdg/argent-argent.directory \
			/usr/share/argent/xdg/*.desktop
	fi

	fdo-mime_desktop_database_update
}

pkg_prerm() {
	if [ -x "/usr/bin/xdg-desktop-menu" ]; then
		xdg-desktop-menu uninstall /usr/share/argent/xdg/argent-argent.directory /usr/share/argent/xdg/*.desktop
	fi
}
