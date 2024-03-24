# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="1.4"
#UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
fi
SLOT="7.3"

src_install() {

		toolchain_src_install

		# define folders to be dropped, as they are provided by sys-devel/gcc-${PV}
		export local bindir="${D}usr/bin"
		export local libexecdir="${D}usr/libexec"
		export local usrdir="${D}usr/${CHOST}"
		export local sharedir="${D}usr/share"
		export local debugdir="${D}usr/lib/debug"
		export local libdir="${D}usr/lib/gcc/${CHOST}/${PV}"

		if use multilib ; then
			export local multilibdir="${D}usr/lib/gcc/${CHOST}/${PV}/32"
		fi

		# drop binaries, debug symbols && headers, they're provided by sys-devel/gcc-${PV}
		for extra in "$bindir" "$libexecdir" "$usrdir" "$sharedir" "$debugdir" "$libdir/include" "$libdir/finclude" "$libdir/include-fixed" "$libdir/plugin" "$libdir/security" ; do
			rm -rf "$extra"
		done
}

pkg_preinst() {
		:
}

pkg_postinst() {
		# Argent specific bits to always force the latest gcc profile
		export local target="${ROOT}etc/env.d/gcc/${CHOST}-${PV}-vanilla"
		if [[ -f "$target" ]] ; then
			elog "Setting: ${target} GCC profile"
			gcc-config "${target}"
		else
			eerror "No sys-devel/base-gcc version installed? Cannot set a proper GCC profile"
		fi
}
