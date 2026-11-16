# Copyright 1999-2015 Gentoo Foundation
# Copyright 2015-2026 Argent Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="8"

inherit git-r3 optfeature

DESCRIPTION="Argent Versatile Advanced Script for ISO and Latest Enhancements"
HOMEPAGE="http://argentlinux.io"

EGIT_BRANCH="argent"
EGIT_REPO_URI="https://gitlab.com/argent/avasile.git"

LICENSE="GPL-2"
SLOT="0/2.4"
KEYWORDS="amd64"
IUSE="server"

DEPEND="
	sys-fs/squashfs-tools
	sys-boot/grub:2
	dev-libs/libisoburn
	sys-fs/mtools"
RDEPEND="${DEPEND}"

pkg_postinst() {
	optfeature "For zero-ing the free space of the ISO rootfs.img (smaller squashfs at ISO build)" sys-fs/zerofree
}
