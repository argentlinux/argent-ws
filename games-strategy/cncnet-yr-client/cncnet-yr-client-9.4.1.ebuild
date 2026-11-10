# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="CnCNet multiplayer client and launcher for Command & Conquer: Yuri's Revenge"
HOMEPAGE="https://cncnet.org/yuris-revenge https://github.com/CnCNet/cncnet-yr-client-package"
SRC_URI="https://github.com/CnCNet/cncnet-yr-client-package/releases/download/yr-${PV}/package_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-3 LGPL-3 MIT BSD Ms-PL ZLIB all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="bindist mirror"

RDEPEND="
	dev-libs/icu
	media-libs/alsa-lib
	virtual/dotnet-sdk:8.0
	virtual/opengl
	virtual/wine[abi_x86_32]
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libxkbcommon
	x11-misc/xdg-utils
	x11-misc/xsel
"
QA_PREBUILT="*"

INSTDIR="/opt/${PN}"

src_prepare() {
	default
	grep -q '^export WINE=wine$' YRLauncherUnix.sh || die "upstream launcher changed, review the WINE override"
	sed -i 's|^export WINE=wine$|export WINE="${WINE:-wine}"|' YRLauncherUnix.sh || die
}

src_install() {
	insinto "${INSTDIR}"
	doins -r .
	fperms 0755 "${INSTDIR}"/YRLauncherUnix.sh \
		"${INSTDIR}"/Resources/Compatibility/Unix/wine-game.sh \
		"${INSTDIR}"/Resources/Compatibility/Unix/CnCNetQM.sh

	newbin "${FILESDIR}"/cncnet-yr cncnet-yr
	domenu "${FILESDIR}"/cncnet-yr.desktop
	doicon -s 128 "${FILESDIR}"/cncnet-yr.png

	dodoc LICENSE.md
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Run 'cncnet-yr' (or the menu entry). On first start the client files are"
	elog "copied to a writable per-user directory, by default:"
	elog "    \${XDG_DATA_HOME:-~/.local/share}/cncnet-yr"
	elog "Override it with the CNCNET_YR_HOME environment variable."
	elog ""
	elog "This package does NOT contain the game. Copy these files from your"
	elog "Red Alert 2 + Yuri's Revenge installation into that directory:"
	elog "    ra2.mix ra2md.mix language.mix langmd.mix BINKW32.DLL"
	elog "    MOVIES01.MIX MOVIES02.MIX movmd03.mix MAPS01.MIX MAPS02.MIX mapsmd03.mix"
	elog "Music is optional: theme.mix and thememd.mix."
	elog ""
	elog "The game runs through the selected Wine (eselect wine) and needs 32-bit"
	elog "support (abi_x86_32 or wow64). The client runs on the .NET 8 runtime."
	elog ""
	elog "The client has its own in-game updater; using it is harmless, but the"
	elog "per-user copy is re-synced from ${INSTDIR} whenever this package is"
	elog "upgraded, which resets any edits to the packaged INI files."
}
