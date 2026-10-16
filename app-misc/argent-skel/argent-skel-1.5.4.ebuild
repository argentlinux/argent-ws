# Distributed under the terms of the GNU General Public License v2

EAPI="8"
EGIT_REPO_URI="https://gitlab.com/argent/argentws-skel.git"

inherit git-r3 xdg xdg-utils

DESCRIPTION="Argent Linux skel tree"
HOMEPAGE="http://argentlinux.io"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="+themes"

RDEPEND="
	themes? (
		x11-themes/argent-artwork-core
		x11-themes/argent-theme-modern
	)
"

pkg_postinst() {
	if [ -x "/usr/bin/xdg-desktop-menu" ]; then
		xdg-desktop-menu install \
			/usr/share/argent/xdg/argent-argent.directory \
			/usr/share/argent/xdg/*.desktop
	fi
}

pkg_prerm() {
	if [ -x "/usr/bin/xdg-desktop-menu" ]; then
		xdg-desktop-menu uninstall /usr/share/argent/xdg/argent-argent.directory /usr/share/argent/xdg/*.desktop
	fi
}
