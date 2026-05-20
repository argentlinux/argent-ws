# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature xdg

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discord.com/"
SRC_URI="https://dl.discordapp.net/apps/linux/${PV}/${P}.tar.gz"

S="${WORKDIR}/${PN^}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"
IUSE="appindicator"
RESTRICT="bindist mirror strip test"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	appindicator? ( dev-libs/libayatana-appindicator )
"

QA_PREBUILT="*"

CONFIG_CHECK="~USER_NS"

src_install() {
	dobin "${PN}"

	insinto "/usr/share/${PN}"
	insopts -m0755
	doins updater_bootstrap
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "Install the following packages for additional support:"
	optfeature "sound support" \
		media-sound/pulseaudio media-sound/apulse[sdk] media-video/pipewire
	optfeature "emoji support" media-fonts/noto-emoji
	if has_version kde-plasma/kwin[-screencast] && use wayland; then
		einfo " "
		einfo "When using KWin on Wayland, the kde-plasma/kwin[screencast] USE flag"
		einfo "must be enabled for screensharing."
		einfo " "
	fi
	einfo "Discord 1.0.x is a bootstrapper: the real client is downloaded to"
	einfo "~/.config/discord/ on first launch and is not managed by Portage."
}
