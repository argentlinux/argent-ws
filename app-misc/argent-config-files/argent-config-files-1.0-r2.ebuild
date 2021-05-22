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
IUSE="+dracut plymouth debug"

DEPEND=""
RDEPEND="
	dracut? (
		sys-kernel/dracut )
	microcode? (
		sys-firmware/intel-microcode )
	debug? (
		dev-util/strace )
	plymouth? (
		sys-boot/plymouth )
	"

S="${FILESDIR}"

src_prepare() {
	default
}

src_install() {
	if use dracut ; then
		insinto /etc/dracut.conf.d/
		doins "${FILESDIR}"/argent-dracut.conf
	fi

	# Adding argent-vbox-state.conf that can take two values only:
	# 0 or 1
	# 1 represents enabled state of argent-config-vbox.service
	# 0 represents disabled state of argent-config-vbox.service
	# Default is: 1
	addread /etc/argent-vbox/
	if [ -e "/etc/argent-vbox/argent-vbox-state.conf" ] ; then
		mapfile -t ARGENT_VBOX_STATE < /etc/argent-vbox/argent-vbox-state.conf
	else
		insinto /etc/argent-vbox/
		doins "${FILESDIR}"/argent-vbox-state.conf
	fi

	if [ "${ARGENT_VBOX_STATE}" != "0" ] ; then
		insinto /etc/argent-vbox/
		ewarn "The state cannot be read"
		ewarn "State is: ${ARGENT_VBOX_STATE}"
	else
		ewarn "Argent VBOX service is on disabled state: 0"
		ewarn "argent-vbox-state.conf will not be overwritten"
	fi

	unset ARGENT_VBOX_STATE

	systemd_dounit "${FILESDIR}"/argent-config-vbox.service
}

pkg_preinst() {
	sed -i 's/splash//g' /etc/default/grub
}

pkg_postinst() {
	mapfile -t ARGENT_VBOX_STATE < /etc/argent-vbox/argent-vbox-state.conf

	if [ "${ARGENT_VBOX_STATE}" = "1" ] ; then
		systemctl enable argent-config-vbox
	fi

	unset ARGENT_VBOX_STATE
}

pkg_postrm() {
	systemctl disable argent-config-vbox
}
