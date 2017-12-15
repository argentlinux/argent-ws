# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}"
else
	SRC_URI=""
	KEYWORDS="amd64 ~arm64 x86"
fi

DESCRIPTION="Fast lightweight tabbed filemanager (Qt port)"
HOMEPAGE="https://wiki.lxde.org/en/PCManFM"

LICENSE="GPL-2+"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	:
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	:
}
