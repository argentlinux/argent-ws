# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="kio-extras"
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm gear.kde.org xdg

DESCRIPTION="SMB KIO worker from kio-extras for browsing Windows and NAS shares"
HOMEPAGE="https://invent.kde.org/network/kio-extras"

LICENSE="GPL-2"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"

RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtsvg-${QTMIN}:6
	kde-apps/libkexiv2:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdnssd-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	net-fs/samba[client]
	>=net-libs/kdsoap-2.2.0:=[qt6(+)]
	>=net-libs/kdsoap-ws-discovery-client-0.3.0
"
RDEPEND="${DEPEND}
	kde-apps/kio-extras:6
	!kde-apps/kio-extras[samba]
	>=kde-frameworks/kded-${KFMIN}:6
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOC=OFF
		-DBUILD_TESTING=OFF
		-DBUILD_ACTIVITIES=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_IMobileDevice=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_PList=ON
		-DWITH_LIBPROXY=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Gperf=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Libmtp=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_TIRPC=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenEXR=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_libssh=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Taglib=ON
		-DWITHOUT_X11=ON
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install

	local keep=(
		usr/$(get_libdir)/qt6/plugins/kf6/kio/smb.so
		usr/$(get_libdir)/qt6/plugins/kf6/kded/smbwatcher.so
		usr/libexec/kf6/smbnotifier
		usr/share/konqueror/dirtree/remote/smb-network.desktop
		usr/share/remoteview/smb-network.desktop
		usr/share/mime/packages/org.kde.kio.smb.xml
	)
	local f
	for f in "${keep[@]}"; do
		mkdir -p "${T}/keep/${f%/*}" || die
		mv "${ED}/${f}" "${T}/keep/${f}" || die
	done
	rm -rf "${ED:?}"/* || die
	mv "${T}"/keep/* "${ED}"/ || die
}
