# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
MY_PN="sisyphus"

inherit eutils python-r1

DESCRIPTION="A simple portage python wrapper which works like other package managers(apt-get/yum/dnf)"
HOMEPAGE="http://argentlinux.io"
SRC_URI="https://github.com/rogentos/sisy-argent/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+gui"

DEPEND="dev-lang/python[sqlite]"
RDEPEND="${DEPEND}
	app-portage/gentoolkit[${PYTHON_USEDEP}]
	dev-python/animation[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	sys-apps/portage[${PYTHON_USEDEP}]
	gui? ( dev-python/PyQt5[designer,gui,widgets,${PYTHON_USEDEP}] )"

src_prepare() {
	default
	eapply ${FILESDIR}/${P}-r3.patch
}

src_install() {
	default

	inject_libsisyphus() {
		# FIXME, ugly hack
		python_moduleinto "$(python_get_sitedir)/.."
		python_domodule src/backend/libsisyphus.py
		rm -rf ${D}$(python_get_sitedir)
	}

	python_foreach_impl inject_libsisyphus

	dosym /usr/share/${MY_PN}/${MY_PN}-cli.py /usr/bin/${MY_PN}
	dosym /usr/share/${MY_PN}/sisy-single-spmsync.py /usr/bin/sisy-single-spmsync
	dodir /var/lib/${MY_PN}/{csv,db}
	if ! use gui; then
		rm -rf ${ED}usr/bin/${MY_N}-gui
		rm -rf ${ED}usr/bin/${MY_PN}-gui-pkexec
		rm -rf ${ED}usr/share/${MY_PN}/*py
		rm -rf ${ED}usr/share/${MY_PN}/icon
		rm -rf ${ED}usr/share/${MY_PN}/ui
		rm -rf ${ED}usr/share/applications
		rm -rf ${ED}usr/share/pixmaps
		rm -rf ${ED}usr/share/polkit-1
	fi
}

pkg_postinst() {
	sisyphus rescue
}
