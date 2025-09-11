# Copyright 2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

if [[ ${PV} == 9999 ]]; then
	inherit meson python-any-r1 gnome2-utils xdg git-r3
else
	inherit meson python-any-r1 gnome2-utils xdg
fi

DESCRIPTION="A system designed to make installation and updates of packages easier"
HOMEPAGE="https://www.freedesktop.org/software/PackageKit/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/TableFlipper9/PackageKit.git"
	EGIT_BRANCH="install"
else
	SRC_URI="https://www.freedesktop.org/software/PackageKit/releases/PackageKit-${PV}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
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
    find . -iname '*portageBackend.py*'
    meson_src_install

    fperms +x ${D}/usr/share/PackageKit/helpers/portage/portageBackend.py
    dosym "vaapigen-${PV}" "/usr/bin/vaapigen"

    dodoc README.md AUTHORS NEWS
}
