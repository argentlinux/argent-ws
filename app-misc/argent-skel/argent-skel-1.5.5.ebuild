# Distributed under the terms of the GNU General Public License v2

EAPI="8"
EGIT_REPO_URI="https://gitlab.com/argent/argentws-skel.git"

inherit git-r3 tmpfiles xdg xdg-utils

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

src_install() {
	default

	insinto /usr/lib/argent
	newins "${FILESDIR}"/argent-os-release os-release
	sed -i "s/@VERSION@/${PV}/g" "${ED}"/usr/lib/argent/os-release || die

	newtmpfiles "${FILESDIR}"/argent-os-release.tmpfiles argent-os-release.conf
}

pkg_postinst() {
	if [ -x "/usr/bin/xdg-desktop-menu" ]; then
		xdg-desktop-menu install \
			/usr/share/argent/xdg/argent-argent.directory \
			/usr/share/argent/xdg/*.desktop
	fi

	cp -f "${EROOT}"/usr/lib/argent/os-release "${EROOT}"/usr/lib/os-release \
		|| ewarn "Could not write ${EROOT}/usr/lib/os-release"
	rm -f "${EROOT}"/etc/os-release
	cp -f "${EROOT}"/usr/lib/argent/os-release "${EROOT}"/etc/os-release \
		|| ewarn "Could not write ${EROOT}/etc/os-release"

	tmpfiles_process argent-os-release.conf
}

pkg_prerm() {
	if [ -x "/usr/bin/xdg-desktop-menu" ]; then
		xdg-desktop-menu uninstall /usr/share/argent/xdg/argent-argent.directory /usr/share/argent/xdg/*.desktop
	fi
}
