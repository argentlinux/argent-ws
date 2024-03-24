# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit  xdg-utils gnome2-utils

SRC_URI="http://download.jetbrains.com/cpp/CLion-${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="A complete toolset for C and C++ development"
HOMEPAGE="http://www.jetbrains.com/clion"
SLOT="0/2018.2"
KEYWORDS="amd64 x86"
LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"

# RDEPENDS may cause false positives in repoman.
# clion requires cmake and gdb at runtime to build and debug C/C++ projects
RDEPEND="|| ( dev-java/icedtea-bin:8
			dev-java/icedtea:8
			dev-java/oracle-jdk-bin:1.8
			)
		sys-devel/gdb
		dev-util/cmake"

RESTRICT="strip stripdebug"
QA_PREBUILT="opt/${P}/*"

src_prepare() {
	default

	local remove_me=(
		bin/gdb/linux
		bin/lldb/linux
		bin/cmake
		license/CMake*
		plugins/tfsIntegration/lib/native/hpux
		plugins/tfsIntegration/lib/native/solaris
	)

	use amd64 || remove_me+=( plugins/tfsIntegration/lib/native/linux/x86_64 )
	use arm || remove_me+=( bin/fsnotifier-arm plugins/tfsIntegration/lib/native/linux/arm )
	use ppc || remove_me+=( plugins/tfsIntegration/lib/native/linux/ppc )
	use x86 || remove_me+=( plugins/tfsIntegration/lib/native/linux/x86 )

	rm -rv "${remove_me[@]}" || die
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{clion.sh,fsnotifier{,64},clang/linux/clang{d,-tidy}}

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "CLion" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
