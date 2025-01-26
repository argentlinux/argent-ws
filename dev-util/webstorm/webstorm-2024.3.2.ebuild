# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="An integrated development environment for JavaScript and related technologies."
HOMEPAGE="https://www.jetbrains.com/webstorm/"
SRC_URI="https://download-cdn.jetbrains.com/${PN}/WebStorm-${PV}.tar.gz"

#S="${WORKDIR}/WebStorm-${PV}"
LICENSE="|| ( JetBrains-business JetBrains-classroom JetBrains-educational JetBrains-individual )
        Apache-2.0
        BSD
        CC0-1.0
        CDDL
        CDDL-1.1
        EPL-1.0
        GPL-2
        GPL-2-with-classpath-exception
        ISC
        LGPL-2.1
        LGPL-3
        MIT
        MPL-1.1
        OFL-1.1
        ZLIB
"
SLOT="0/2024"
KEYWORDS="~amd64"
IUSE="wayland"

RESTRICT="bindist mirror splitdebug"
QA_PREBUILT="opt/${P}/*"

BDEPEND="app-alternatives/tar"
RDEPEND="dev-libs/libdbusmenu
        llvm-core/lldb
        sys-process/audit
        media-libs/mesa[X(+)]
        x11-libs/libX11
        x11-libs/libXcomposite
        x11-libs/libXcursor
        x11-libs/libXdamage
        x11-libs/libXext
        x11-libs/libXfixes
        x11-libs/libXi
        x11-libs/libXrandr
"

src_unpack() {
        cp "${DISTDIR}"/WebStorm-${PV}.tar.gz "${WORKDIR}"
        mkdir -p "${P}"
        tar --strip-components=1 -xzf "WebStorm-${PV}".tar.gz -C "${P}" || die
}

src_prepare() {
        default

        local remove_me=(
            lib/async-profiler/aarch64
        )

        rm -rv "${remove_me[@]}" || die

        patchelf --set-rpath '$ORIGIN' "jbr/lib/libjcef.so" || die
        patchelf --set-rpath '$ORIGIN' "jbr/lib/jcef_helper" || die

        if use wayland; then
                echo "-Dawt.toolkit.name=WLToolkit" >> bin/webstorm64.vmoptions
        fi
}

src_install() {
        local dir="/opt/${P}"

        insinto "${dir}"
        doins -r *
        fperms 755 "${dir}"/bin/{"${PN}",fsnotifier,format.sh,inspect.sh,jetbrains_client.sh,ltedit.sh,remote-dev-server,remote-dev-server.sh,restarter}
        fperms 755 "${dir}"/jbr/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,keytool,rmiregistry,serialver}
        fperms 755 "${dir}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}

        make_wrapper "${PN}" "${dir}"/bin/"${PN}"
        newicon bin/"${PN}".svg "${PN}".svg
        make_desktop_entry "${PN}" "WebStorm ${PN}" "${PN}" "Development;IDE;"
}

pkg_postinst() {
        if [[ -z "${REPLACING_VERSIONS}" ]]; then
                        # This is a new installation, so:
                        echo
                        elog "It is strongly recommended to increase the inotify watch limit"
                        elog "to at least 524288. You can achieve this e.g. by calling"
                        elog "echo \"fs.inotify.max_user_watches = 524288\" > /etc/sysctl.d/30-idea-inotify-watches.conf"
                        elog "and reloading with \"sysctl --system\" (and restarting the IDE)."
                        elog "For details see:"
                        elog "    https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit"
        fi

        local replacing_version
        for replacing_version in ${REPLACING_VERSIONS} ; do
                if ver_test "${replacing_version}" -lt "2019.3-r1"; then
                        # This revbump requires user interaction.
                        echo
                        ewarn "Previous versions configured fs.inotify.max_user_watches without user interaction."
                        ewarn "Since version 2019.3-r1 you need to do so manually, e.g. by calling"
                        ewarn "echo \"fs.inotify.max_user_watches = 524288\" > /etc/sysctl.d/30-idea-inotify-watches.conf"
                        ewarn "and reloading with \"sysctl --system\" (and restarting the IDE)."
                        ewarn "For details see:"
                        ewarn "    https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit"

                        # Show this ewarn only once
                        break
                fi
        done
}