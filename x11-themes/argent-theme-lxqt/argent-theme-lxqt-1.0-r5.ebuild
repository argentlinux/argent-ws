# Copyright 2015 Rogentos
# Distributed under the terms of the GNU General Public License v3
# Maintainer bionel <bionel @ rogentos.ro >

EAPI=5

inherit eutils git-2

DESCRIPTION="Official Argent-Linux LXQT theme"
HOMEPAGE="http://www.rogentos.ro"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://gitlab.com/argent/argent-theme-lxqt.git"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RDEPEND=""

src_install() {
	rm README.md
	dodir /usr/share/lxqt/themes
	insinto /usr/share/lxqt/themes
	doins -r *
}
