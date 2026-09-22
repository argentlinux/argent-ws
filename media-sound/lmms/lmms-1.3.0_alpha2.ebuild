# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Cross-platform music production software"
HOMEPAGE="https://lmms.io"
EGIT_REPO_URI="https://github.com/LMMS/lmms.git"
EGIT_COMMIT="v1.3.0-alpha.2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa fltk fluidsynth gig jack +lv2 mp3 +ogg portaudio +pulseaudio sdl sid sndio stk suil"

REQUIRED_USE="suil? ( lv2 )"

COMMON_DEPEND="
	dev-qt/qtbase:6[gui,widgets,xml]
	dev-qt/qtsvg:6
	>=media-libs/libsamplerate-0.1.8
	media-libs/libsndfile
	sci-libs/fftw:3.0
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	fltk? ( x11-libs/fltk:1 )
	fluidsynth? ( media-sound/fluidsynth )
	gig? ( media-libs/libgig )
	jack? ( virtual/jack )
	lv2? ( media-libs/lilv )
	mp3? ( media-sound/lame )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl2 )
	sndio? ( media-sound/sndio )
	stk? ( media-libs/stk )
	suil? ( media-libs/suil )
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	media-plugins/calf
	media-plugins/caps-plugins
	media-plugins/cmt-plugins
	media-plugins/swh-plugins
	media-plugins/tap-plugins
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

DOCS=( README.md doc/AUTHORS )

src_configure() {
	local mycmakeargs=(
		-DWANT_QT6=ON
		-DUSE_WERROR=OFF
		-DWANT_ALSA=$(usex alsa)
		-DWANT_CALF=OFF
		-DWANT_CAPS=OFF
		-DWANT_CARLA=OFF
		-DWANT_CMT=OFF
		-DWANT_GIG=$(usex gig)
		-DWANT_JACK=$(usex jack)
		-DWANT_LV2=$(usex lv2)
		-DWANT_MP3LAME=$(usex mp3)
		-DWANT_OGGVORBIS=$(usex ogg)
		-DWANT_PORTAUDIO=$(usex portaudio)
		-DWANT_PULSEAUDIO=$(usex pulseaudio)
		-DWANT_SDL=$(usex sdl)
		-DWANT_SF2=$(usex fluidsynth)
		-DWANT_SID=$(usex sid)
		-DWANT_SNDIO=$(usex sndio)
		-DWANT_STK=$(usex stk)
		-DWANT_SUIL=$(usex suil)
		-DWANT_SWH=OFF
		-DWANT_TAP=OFF
		-DWANT_VST=OFF
		-DWANT_WEAKJACK=OFF
	)
	cmake_src_configure
}
