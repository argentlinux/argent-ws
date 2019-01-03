# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils xdg-utils gnome2-utils versionator

MY_PN="WebStorm"
SRC_URI="http://download.jetbrains.com/${PN}/${MY_PN}-$(get_version_component_range 1-3).tar.gz"
DESCRIPTION="WebStorm IDE by JetBrains"
HOMEPAGE="http://www.jetbrains.com/webstorm"
SLOT="0/2018.3"
KEYWORDS="amd64"
LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"

QA_PREBUILT="opt/${P}/*"
RESTRICT="strip mirror"

S="${WORKDIR}/${MY_PN}-$(get_version_component_range 4-6)/"

DEPEND=""
RDEPEND="|| ( dev-java/icedtea-bin:8
		dev-java/icedtea:8
		dev-java/oracle-jdk-bin:1.8
		)"

pkg_setup() {
	if [[ -z $(get_version_component_range 6) ]] ; then
		export S="${WORKDIR}/${MY_PN}-$(get_version_component_range 3-5)"
	fi
}

src_prepare() {
	default
	if ! use arm; then
		rm -rf bin/fsnotifier-arm || die
	fi
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{${PN}.sh,fsnotifier{,64}}

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "WebStorm" "${PN}" "Development;IDE;"

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
