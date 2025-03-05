# Copyright 1999-2018 Gentoo Foundation
# Copyright 2018-2025 Argent Linux Developers
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit git-r3 xdg

DESCRIPTION="Icon theme following the Google's material design specifications"
HOMEPAGE="https://gitlab.com/argent/bionel-icons"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://gitlab.com/argent/bionel-icons"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

src_install() {
	rm "${S}"/material-icons/material-design-darkyellow/scalable/places/start-here.svg || exit 1
	dodir usr/share/icons
	insinto usr/share/icons
	doins -r material-icons/*
	insinto usr/share/icons/material-design-darkyellow/scalable/places/
	doins "${FILESDIR}"/start-here.svg
}
