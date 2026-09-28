# Copyright 2015 Rogentos
# Copyright 2015-2026 Argent Linux Developers
# Distributed under the terms of the GNU General Public License v3
# Maintainer bionel <bionel @ rogentos.ro >

EAPI="8"

inherit  git-r3

DESCRIPTION="Official Argent-Linux GTK and LXQT theme"
HOMEPAGE="https://argentlinux.io"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://gitlab.com/argent/argent-theme.git"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~arm x86 amd64"
IUSE="lxqt"
RDEPEND="lxqt? ( !x11-themes/argent-theme-lxqt )"

src_install() {
	rm README.md
	rm to_review
	if ! use lxqt ; then
		rm -r lxqt-themes || die
	fi
	insinto /usr/share/themes
	doins -r *
}
