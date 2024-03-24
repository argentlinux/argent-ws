# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="7"

inherit linux-mod 

MY_P="vbox-kernel-module-src-${PV}"
DESCRIPTION="Kernel Modules source for Virtualbox"
HOMEPAGE="http://www.virtualbox.org/"
SRC_URI="https://dev.gentoo.org/~polynomial-c/virtualbox/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="pax_kernel"

DEPEND="sys-kernel/dkms"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
    if kernel_is -ge 2 6 33 ; then
        # evil patch for new kernels - header moved
        grep -lR linux/autoconf.h *  | xargs sed -i -e 's:<linux/autoconf.h>:<generated/autoconf.h>:'
    fi

    if use pax_kernel && kernel_is -ge 3 0 0 ; then
        epatch "${FILESDIR}"/${PN}-4.1.4-pax-const.patch
    fi
}

src_compile() {
	:
}

src_install() {
	cp "${FILESDIR}"/dkms-"${PV}".conf "${S}"/dkms.conf || die
	dodir /usr/src/"${P}"
	insinto /usr/src/"${P}"
	doins -r "${S}"/*
}

pkg_postinst() {
	dkms add "${PN}/${PV}"
}

pkg_prerm() {
	dkms remove "${PN}/${PV}" --all
}
