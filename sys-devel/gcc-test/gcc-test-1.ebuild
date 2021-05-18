# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
set -x

SRC_URI="http://localhost/packaged-gcc.tar.xz"

DESCRIPTION="Virtual for user account management utilities"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

S="${WORKDIR}/base-gcc-9.3.0"

src_install() {
	set -x
	insinto /usr/lib/gcc/x86_64_almeu/
	ls -la "${D}"
	export local libdir="${D}/usr/"

	rm -rf "${libdir}" || exit 1
	ls -la "${D}"
	exit 1
}
