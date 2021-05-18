# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker

DESCRIPTION="Debian package for Klibc"
HOMEPAGE=""
SRC_URI="http://ftp.us.debian.org/debian/pool/main/k/klibc/libklibc_${PV}-6_amd64.deb"

LICENSE=""
SLOT="2.0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	sys-devel/bc"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	insinto /usr/share/fanelu
	doins usr/
}
