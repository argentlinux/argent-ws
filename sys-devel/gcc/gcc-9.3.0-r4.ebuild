# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="3"

inherit toolchain

set -x

KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
fi

SLOT="9.3"

src_install() {
		toolchain_src_install
		# drop base gcc libraries, they're provided by sys-devel/base-gcc-${PV}
		export local libdir="${D}/usr/lib/gcc/${CHOST}/${PV}"
		if use multilib ; then
			export local multilibdir="${D}/usr/lib/gcc/${CHOST}/${PV}/32"
		fi

		# if we remove whole libdir, headers are gone, so remove only libs and their symlinks
		find "$libdir" -maxdepth 1 -type f -delete
		find "$libdir" -maxdepth 1 -type l -delete
		# however, removing multilibdir as a whole doesn't cause any problems
		if use multilib ; then
			rm -rf "$multilibdir"
		fi

		# drop golibs, they're provided by sys-devel/base-gcc-{PV}
		if [[ "$(uname -m)" = "x86_64" ]] ; then
			export local golibdir="${D}/usr/lib64/go/${PV}"
		if use multilib ; then
			export local gomultilibdir="${D}/usr/lib32/go/${PV}"
		fi
		elif [[ "$(uname -m)" = "i686" ]] ; then
			export local golibdir="${D}/usr/lib/go/${PV}"
		fi

		rm -rf "$golibdir"
		if use multilib ; then
			rm -rf "$gomultilibdir"
		fi

		# drop gcjlibs, they're provided by sys-devel/base-gcc-${PV}
		if [[ "$(uname -m)" = "x86_64" ]] ; then
			export local gcjlibdir="${D}/usr/lib64/gcj-${PV}-16"
		if use multilib ; then
			export local gcjmultilibdir="${D}/usr/lib32/gcj-${PV}-16"
		fi
		elif [[ "$(uname -m)" = "i686" ]] ; then
			export local gcjlibdir="${D}/usr/lib/gcj-${PV}-16"
		fi

		rm -rf "$gcjlibdir"
			if use multilib ; then
			rm -rf "$gcjmultilibdir"
		fi

		# drop pkgconfig files, they're provided by sys-devel/base-gcc-${PV}
		if [[ "$(uname -m)" = "x86_64" ]] ; then
			export local pkgconfigdir="${D}/usr/lib64/pkgconfig"
		if use multilib ; then
			export local pkgconfigmultilibdir="${D}/usr/lib32/pkgconfig"
		fi
		elif [[ "$(uname -m)" = "i686" ]] ; then
			export local pkgconfigdir="${D}/usr/lib/pkgconfig"
		fi

		rm -rf "$pkgconfigdir"
		if use multilib ; then
			rm -rf "$pkgconfigmultilibdir"
		fi

		# drop gcc profiles, they're provided by sys-devel/base-gcc-${PV}
		export local envdir="${D}/etc"
		rm -rf "$envdir"
}

pkg_preinst() {
		:
}

pkg_postinst() {
		:
}
