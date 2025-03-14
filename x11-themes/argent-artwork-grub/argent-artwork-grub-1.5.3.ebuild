# Copyright 1999-2015 Gentoo Foundation
# Copyright 2015-2025 Argent Linux Developers
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 toolchain-funcs

DESCRIPTION="Argent-Linux GRUB2 Images"
HOMEPAGE="http://argentlinux.io"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://gitlab.com/argent/boot-core.git"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE=""
RDEPEND=""

src_install() {
	insinto /usr/share/grub/themes
	doins -r "${S}"/cdroot/boot/grub/themes/argent
}
