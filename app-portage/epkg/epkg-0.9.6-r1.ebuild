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

DEPEND="sys-devel/gettext"
RDEPEND="app-portage/gentoolkit
		app-portage/portage-utils
		sys-apps/coreutils
		sys-apps/portage
		git? ( dev-vcs/git[curl] )
"
REQUIRED_USE="|| ( argent gentoo )
		argent? ( !gentoo )
		gentoo? ( !argent )"

src_install() {
	dobin epkg
	dodir /usr/$(get_libdir)/"${PN}"
	insinto /usr/$(get_libdir)/"${PN}"

	if use gentoo ; then
		export GENTOO_DISTRO="gentoo"
		envsubst '${GENTOO_DISTRO}' < "${S}/libepkg" > "${S}/libepkg.new" && mv "${S}/libepkg.new" "${S}/libepkg"
		doins "${S}/libepkg"
	else
		export GENTOO_DISTRO="argent"
		envsubst '${GENTOO_DISTRO}' < "${S}/libepkg" > "${S}/libepkg.new" && mv "${S}/libepkg.new" "${S}/libepkg"
		doins "${S}/libepkg"
	fi

	dodir /usr/share/epkg/backups/
}
