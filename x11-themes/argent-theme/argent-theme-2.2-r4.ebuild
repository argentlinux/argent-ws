# Copyright 2015 Rogentos
# Copyright 2015-2025 Argent Linux Developers
# Distributed under the terms of the GNU General Public License v3
# Maintainer bionel <bionel @ rogentos.ro >

EAPI="7"

inherit  git-r3

DESCRIPTION="Official Argent-Linux GTK theme"
HOMEPAGE="http://www.rogentos.ro"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://gitlab.com/argent/argent-theme.git"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~arm x86 ~amd64"
IUSE=""
RDEPEND=""

src_install() {
	rm README.md
	rm to_review
	insinto /usr/share/themes
	doins -r *
}
