# Copyright 1999-2015 Gentoo Foundation
# Copyright 2015-2025 Rogentos / Argent
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="8"

DESCRIPTION="Argent simple portage wrapper which works like any other package manager"
HOMEPAGE="http://argentlinux.io"
SRC_URI="https://gitlab.com/argent/epkg/-/archive/${PVR}/${PF}.tar.gz"

# EGIT_BRANCH=master
# EGIT_REPO_URI="https://gitlab.com/argent/epkg.git"

LICENSE="BSD-2"
SLOT="0/0.9"
KEYWORDS="amd64 x86"
IUSE="+argent gentoo git"

S="${WORKDIR}/${PN}-${PVR}"

RDEPEND="app-portage/gentoolkit
		app-portage/portage-utils
		sys-apps/coreutils
		sys-apps/portage
		argent? (
			sec-keys/openpgp-keys-argent
			sec-keys/openpgp-keys-gentoo-developers
		)
		git? ( dev-vcs/git[curl] )
"
REQUIRED_USE="|| ( argent gentoo )
		argent? ( !gentoo )
		gentoo? ( !argent )"

src_install() {
	dobin epkg
	sed -i "s|\${GENTOO_DISTRO}|$(usex gentoo gentoo argent)|" libepkg || die
	insinto /usr/$(get_libdir)/"${PN}"
	doins libepkg

	dodir /usr/share/epkg/backups/
}
