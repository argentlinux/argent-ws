# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="LSB version query program"
HOMEPAGE="https://wiki.linuxfoundation.org/lsb/"
SRC_URI="mirror://sourceforge/lsb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

# Perl isn't needed at runtime, it is just used to generate the man page.
DEPEND="dev-lang/perl"
RDEPEND=""

src_unpack() {
	unpack "${A}" || die
	cd "${S}" || die
    epatch "${FILESDIR}"/${PN}-argent-version.patch
    epatch "${FILESDIR}"/${P}-os-release.patch
}

src_install() {
	emake \
		prefix="${D}/usr" \
		mandir="${D}/usr/share/man" \
		install \
		|| die "emake install failed"

	mkdir -p "${D}/etc"
	cat > "${D}/etc/lsb-release" <<- EOF
		DISTRIB_ID="Argent"
	EOF
}
