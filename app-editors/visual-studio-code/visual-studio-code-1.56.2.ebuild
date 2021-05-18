# Copyright 1999-2017 Gentoo Foundation
# Copyright 2017-2021 RogentOS Team
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils pax-utils

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"
BASE_URI="https://update.code.visualstudio.com/${PV}"
SRC_URI="
	amd64? ( ${BASE_URI}/linux-x64/stable -> ${P}-amd64.tar.gz )
	"
RESTRICT="mirror strip bindist"

LICENSE="EULA MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	>=x11-libs/gtk+-2.24.31-r1:2
	>=media-libs/libpng-1.2.46:0
	x11-libs/cairo
	x11-libs/libXtst
"

RDEPEND="
	${DEPEND}
	>=dev-libs/nss-3.47.1-r1:0
	>=net-print/cups-2.0.0
	>=x11-libs/libnotify-0.7.7:0
	>=x11-libs/libXScrnSaver-1.2.2-r1:0
	>=app-crypt/libsecret-0.18.5:0[crypt]
"

QA_PRESTRIPPED="opt/${PN}/code"
QA_PREBUILT="opt/${PN}/code"

pkg_setup(){
	use amd64 && S="${WORKDIR}/VSCode-linux-x64" || S="${WORKDIR}/VSCode-linux-ia32"
}

src_install(){
	pax-mark m code
	insinto "/opt/${PN}"
	doins -r *
	dosym "/opt/${PN}/bin/code" "/usr/bin/${PN}"
	make_desktop_entry "${PN}" "Visual Studio Code" "${PN}" "Development;IDE"
	doicon ${FILESDIR}/${PN}.png
	fperms +x "/opt/${PN}/code"
	fperms +x "/opt/${PN}/bin/code"
	fperms +x "/opt/${PN}/libEGL.so"
	fperms +x "/opt/${PN}/libGLESv2.so"
	fperms +x "/opt/${PN}/libffmpeg.so"
	fperms +x "/opt/${PN}/swiftshader/libEGL.so"
	fperms +x "/opt/${PN}/swiftshader/libGLESv2.so"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
	insinto "/usr/share/licenses/${PN}"
	newins "resources/app/extensions/ms-vscode.node-debug/LICENSE.txt" "LICENSE"
}

pkg_postinst(){
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
