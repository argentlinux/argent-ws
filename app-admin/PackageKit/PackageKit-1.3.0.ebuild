# Copyright 2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-any-r1 gnome2-utils xdg

DESCRIPTION="A system designed to make installation and updates of packages easier"
HOMEPAGE="https://www.freedesktop.org/software/PackageKit/"
SRC_URI="https://www.freedesktop.org/software/PackageKit/releases/PackageKit-${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="introspection policykit bash-completion cron gtk-doc systemd test vala"

RESTRICT="!test? ( test )"

REQUIRED_USE=""

DEPEND="
    dev-libs/glib:2
    dev-db/sqlite:3
    sys-apps/portage
    dev-build/meson
    virtual/pkgconfig
    dev-util/intltool
    policykit? ( sys-auth/polkit )
    introspection? ( dev-libs/gobject-introspection )
    vala? ( dev-lang/vala )
"
RDEPEND="${DEPEND}
    bash-completion? ( app-shells/bash-completion )
"

PATCHES=( "${FILESDIR}/packagekit-fix-install-mode.patch" )

src_configure() {
    local emesonargs=(
        -Dpackaging_backend=portage
        -Dgstreamer_plugin=false
        -Dgtk_doc=$(usex gtk-doc true false)
        -Dgtk_module=false
        -Dcron=$(usex cron true false)
        -Dsystemd=$(usex systemd true false)
    )

    meson_src_configure
}

src_install() {
    meson_src_install

    # Optional cleanup or reorganization for Gentoo style
    dodoc README.md AUTHORS NEWS
}