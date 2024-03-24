# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit  java-vm-2 toolchain-funcs prefix ver_*

# This URI needs to be updated when bumping!
JDK_URI="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"

SLOT="${PV:0:2}"


# This is a list of archs supported by this update.
# Currently arm comes and goes.
AT_AVAILABLE=( amd64 arm arm64 x86 x64-solaris sparc64-solaris x64-macos )

# Sometimes some or all of the demos are missing, this is to not have to rewrite half
# the ebuild when it happens.
DEMOS_AVAILABLE=( amd64 arm arm64 x86 x64-solaris sparc64-solaris x64-macos )

if [[ "$(get_version_component_range 4)" == 0 ]] ; then
	S_PV="$(get_version_component_range 1-3)"
else
	MY_PV_EXT="$(get_version_component_range 4)"
	S_PV="$(get_version_component_range 1-4)"
fi

MY_PV="$(get_version_component_range 2)${MY_PV_EXT}"

AT_amd64="zulu${MY_PV}-ca-jdk${PV:9}-linux_x64.tar.gz"
AT_arm="jdk-${MY_PV}-linux-arm32-vfp-hflt.tar.gz"
AT_arm64="jdk-${MY_PV}-linux-arm64-vfp-hflt.tar.gz"
AT_x86="jdk-${MY_PV}-linux-i586.tar.gz"
AT_x64_solaris="jdk-${MY_PV}-solaris-x64.tar.gz"
AT_sparc64_solaris="${AT_sparc_solaris} jdk-${MY_PV}-solaris-sparcv9.tar.gz"
AT_x64_macos="jdk-${MY_PV}-macosx-x64.dmg"

DEMOS_amd64="jdk-${MY_PV}-linux-x64-demos.tar.gz"
DEMOS_arm="jdk-${MY_PV}-linux-arm32-vfp-hflt-demos.tar.gz"
DEMOS_arm64="jdk-${MY_PV}-linux-arm64-vfp-hflt-demos.tar.gz"
DEMOS_x86="jdk-${MY_PV}-linux-i586-demos.tar.gz"
DEMOS_x64_solaris="jdk-${MY_PV}-solaris-x64-demos.tar.gz"
DEMOS_sparc64_solaris="jdk-${MY_PV}-solaris-sparcv9-demos.tar.gz"
DEMOS_x64_macos="jdk-${MY_PV}-macosx-x86_64-demos.zip"

DESCRIPTION="Zulu's Java SE Development Kit"
HOMEPAGE="http://cdn.azul.com/"
SRC_URI="https://cdn.azul.com/zulu/bin/zulu${PV:0:8}-ca-jdk${PV:9}-linux_x64.tar.gz"
LICENSE="Zulu-BCLA-JavaSE examples? ( BSD )"

KEYWORDS="~amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"
IUSE="alsa commercial cups derby doc examples +fontconfig gentoo-vm headless-awt -javafx jce nsplugin selinux source visualvm"
REQUIRED_USE="javafx? ( alsa fontconfig )"

RESTRICT="preserve-libs strip"
QA_PREBUILT="*"

# NOTES:
#
# * cups is dlopened.
#
# * libpng is also dlopened but only by libsplashscreen, which isn't
#   important, so we can exclude that.
#
# * We still need to work out the exact AWT and JavaFX dependencies
#   under MacOS. It doesn't appear to use many, if any, of the
#   dependencies below.
#
RDEPEND="!x64-macos? (
		!headless-awt? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXi
			x11-libs/libXrender
			x11-libs/libXtst
		)
		javafx? (
			dev-libs/glib:2
			dev-libs/libxml2:2
			dev-libs/libxslt
			media-libs/freetype:2
			x11-libs/cairo
			x11-libs/gtk+:2
			x11-libs/libX11
			x11-libs/libXtst
			x11-libs/libXxf86vm
			x11-libs/pango
			virtual/opengl
		)
	)
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	doc? ( dev-java/java-sdk-docs:${SLOT} )
	fontconfig? ( media-libs/fontconfig:1.0 )
	!prefix? ( sys-libs/glibc:* )
	selinux? ( sec-policy/selinux-java )"

DEPEND="app-arch/zip
	examples? ( x64-macos? ( app-arch/unzip ) )"

S="${WORKDIR}/zulu${PV:0:8}-ca-jdk${PV:9}-linux_x64/"

check_tarballs_available() {
	local uri=$1; shift
	local dl= unavailable=
	for dl in "${@}" ; do
		[[ ! -f "${DISTDIR}/${dl}" ]] && unavailable+=" ${dl}"
	done

	if [[ -n "${unavailable}" ]] ; then
		if [[ -z ${_check_tarballs_available_once} ]] ; then
			einfo
			einfo "Zulu requires you to download the needed files manually after"
			einfo "accepting their license through a javascript capable web browser."
			einfo
			_check_tarballs_available_once=1
		fi
		einfo "Download the following files:"
		for dl in ${unavailable}; do
			einfo "  ${dl}"
		done
		einfo "at '${uri}'"
		einfo "and move them to '${DISTDIR}'"
		einfo
		einfo "If the above mentioned urls do not point to the correct version anymore,"
		einfo "please download the files from Zulu's java download archive:"
		einfo
	fi
}

pkg_nofetch() {
	local distfiles=( $(eval "echo \${$(echo AT_${ARCH/-/_})}") )
	if use examples && has ${ARCH} "${DEMOS_AVAILABLE[@]}"; then
		distfiles+=( $(eval "echo \${$(echo DEMOS_${ARCH/-/_})}") )
	fi
	check_tarballs_available "${JDK_URI}" "${distfiles[@]}"
}

src_unpack() {
	default
}

src_prepare() {
	default

	if [[ -n ${JAVA_PKG_STRICT} ]] ; then
		# Mark this binary early to run it now.
		pax-mark m ./bin/javap

		eqawarn "Ensure that this only calls trackJavaUsage(). If not, see bug #559936."
		eqawarn
		eqawarn "$(./bin/javap -J-Duser.home=${T} -c sun.misc.PostVMInitHook || die)"
	fi

	# Remove the hook that calls Zulu's evil usage tracker. Not just
	# because it's evil but because it breaks the sandbox during builds
	# and we can't find any other feasible way to disable it or make it
	# write somewhere else. See bug #559936 for details.
	#zip -d jre/lib/rt.jar sun/misc/PostVMInitHook.class || die
	# peculiarly enough, there is no more PostVMInitHook here
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED%/}/${dest#/}"

	if ! use alsa ; then
		rm -v lib/libjsound.* || die
	fi

	if ! use commercial; then
		rm -vfr lib/missioncontrol jre/lib/jfr* || die
	fi

	if use headless-awt ; then
		rm -v lib/lib*{[jx]awt,splashscreen}* || die
	fi

	if ! use javafx ; then
		rm -vf jre/lib/*/lib*{decora,fx,glass,prism}* \
		   jre/lib/*/libgstreamer-lite.* {,jre/}lib/{,ext/}*fx* \
		   bin/*javafx* bin/javapackager || die
	fi

	if ! use nsplugin ; then
		rm -vf jre/lib/*/libnpjp2.* || die
	else
		local nsplugin=$(echo jre/lib/*/libnpjp2.*)
	fi

	rm -v lib/security/cacerts || die
	dosym ../../../../etc/ssl/certs/java/cacerts \
		"${dest}"/lib/security/cacerts

	# Even though plugins linked against multiple ffmpeg versions are
	# provided, they generally lag behind what Gentoo has available.
	rm -vf jre/lib/*/libavplugin* || die

	# Packaged as dev-util/visualvm but some users prefer this version.
	use visualvm || find -name "*visualvm*" -exec rm -vfr {} + || die

	dodoc DISCLAIMER
	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	if use examples && has ${ARCH} "${DEMOS_AVAILABLE[@]}" ; then
		cp -pPR jfc nbproject "${ddest}" || die
	fi

	if use nsplugin ; then
		local nsplugin_link=${nsplugin##*/}
		nsplugin_link=${nsplugin_link/./-${PN}-${SLOT}.}
		dosym "${dest}/${nsplugin}" "/usr/$(get_libdir)/nsbrowser/plugins/${nsplugin_link}"
	fi

	if use source ; then
		cp -v src.zip "${ddest}" || die

		if use javafx ; then
			cp -v javafx-src.zip "${ddest}" || die
		fi
	fi

	if [[ -d jre/lib/desktop ]] ; then
		# Install desktop file for the Java Control Panel.
		# Using ${PN}-${SLOT} to prevent file collision with jre and or
		# other slots.  make_desktop_entry can't be used as ${P} would
		# end up in filename.
		newicon jre/lib/desktop/icons/hicolor/48x48/apps/sun-jcontrol.png \
			sun-jcontrol-${PN}-${SLOT}.png || die
		sed -e "s#Name=.*#Name=Java Control Panel for Zulu JDK ${SLOT}#" \
			-e "s#Exec=.*#Exec=/opt/${P}/jre/bin/jcontrol#" \
			-e "s#Icon=.*#Icon=sun-jcontrol-${PN}-${SLOT}#" \
			-e "s#Application;##" \
			-e "/Encoding/d" \
			jre/lib/desktop/applications/sun_java.desktop \
			> "${T}"/jcontrol-${PN}-${SLOT}.desktop || die
		domenu "${T}"/jcontrol-${PN}-${SLOT}.desktop
	fi

	# provide stable symlink
	dosym "${P}" "/opt/${PN}-${SLOT}"

	use gentoo-vm && java-vm_install-env "${FILESDIR}"/${PN}-${SLOT}.env.sh

	# Prune all fontconfig files so libfontconfig will be used and only install
	# a Gentoo specific one if fontconfig is disabled.
	# http://docs.oracle.com/javase/8/docs/technotes/guides/intl/fontconfig.html
	if ! use fontconfig ; then
		cp "${FILESDIR}"/fontconfig.Gentoo.properties "${T}"/fontconfig.properties || die
		eprefixify "${T}"/fontconfig.properties
		insinto "${dest}"/jre/lib/
		doins "${T}"/fontconfig.properties
	fi

	# This needs to be done before CDS - #215225
	java-vm_set-pax-markings "${ddest}"

	# Remove empty dirs we might have copied.
	find "${D}" -type d -empty -exec rmdir -v {} + || die

	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}

pkg_postinst() {
	java-vm-2_pkg_postinst

	if ! use headless-awt && ! use javafx; then
		ewarn "You have disabled the javafx flag. Some modern desktop Java applications"
		ewarn "require this and they may fail with a confusing error message."
	fi
	if use gentoo-vm ; then
		ewarn "WARNING! You have enabled the gentoo-vm USE flag, making this JDK"
		ewarn "recognised by the system. This will almost certainly break"
		ewarn "many java ebuilds as they are not ready for openjdk-11"
	else
		ewarn "The experimental gentoo-vm USE flag has not been enabled so this JDK"
		ewarn "will not be recognised by the system. For example, simply calling"
		ewarn "\"java\" will launch a different JVM. This is necessary until Gentoo"
		ewarn "fully supports Java 11. This JDK must therefore be invoked using its"
		ewarn "absolute location under ${EPREFIX}/opt/${P}."
	fi
}
