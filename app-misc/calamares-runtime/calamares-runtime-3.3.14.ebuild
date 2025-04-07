# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

PYTHON_COMPAT=( python3_12 )

DESCRIPTION="Calamares distribution-independent installer framework runtime meta-package (containing all the runtime dependencies)"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="+branding networkmanager upower"

DEPEND="
	branding? ( >=x11-themes/argent-artwork-calamares-1.0 )
	>=dev-libs/boost-1.55.0-r2[python_targets_python3_5]
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	sys-apps/dbus
	sys-apps/dmidecode
	sys-auth/polkit-qt[qt6(-)]"
RDEPEND="${DEPEND}
	dev-libs/libatasmart
	sys-apps/systemd[boot(-)]
	virtual/udev
	networkmanager? ( net-misc/networkmanager )
	upower? ( sys-power/upower )
"
