# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="Argent config files"
HOMEPAGE="https://argentlinux.io"
#SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND=""

S="${FILESDIR}"

src_prepare() {
	default
}

src_install() {
	insinto /etc/dracut.conf.d/
	doins "${FILESDIR}"/argent-dracut.conf

	systemd_dounit "${FILESDIR}"/argent-config-vbox.service
}

pkg_preinst() {
	sed -i 's/splash//g' /etc/default/grub
}

pkg_postinst() {
	systemctl enable argent-config-vbox
}
