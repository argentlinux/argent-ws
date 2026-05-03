# Copyright 2024-2026 Argent
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: argent-kernel-utils.eclass
# @MAINTAINER:
# Argent Linux Kernel Project <website@rogentos.ro>
# @SUPPORTED_EAPIS: 8
# @BLURB: Utility functions for Argent Linux kernel and kernel modules
# @DESCRIPTION:
# This eclass provides variables and helper functions related to the
# Argent Linux kernel (sys-kernel/linux-argent) and its module tracking
# via the "arg-kernel" USE flag.
#
# It is safe to inherit from both kernel packages (via argent-kernel.eclass)
# and from kernel module packages (directly, without argent-kernel.eclass).
#
# @EXAMPLE: Adding arg-kernel support to a module package
#
# @CODE
# inherit argent-kernel-utils linux-mod-r1
#
# IUSE="arg-kernel"
# RDEPEND="arg-kernel? ( ${ARG_KERNEL_DEP} )"
#
# pkg_postinst() {
#     linux-mod-r1_pkg_postinst
#     argent-kernel_check_arg_kernel
# }
# @CODE

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_ARGENT_KERNEL_UTILS_ECLASS} ]]; then
_ARGENT_KERNEL_UTILS_ECLASS=1

# @ECLASS_VARIABLE: ARG_KERNEL_DEP
# @DESCRIPTION:
# Dependency string to be used by kernel module packages that want to be
# automatically rebuilt whenever a new Argent Linux kernel is installed.
#
# Add this to RDEPEND conditioned on USE=arg-kernel:
#
#   IUSE="arg-kernel"
#   RDEPEND="arg-kernel? ( ${ARG_KERNEL_DEP} )"
#
# The subslot dependency (:=) causes portage to schedule a rebuild of the
# module package whenever virtual/arg-kernel changes its subslot, which
# happens each time a new sys-kernel/linux-argent version is installed.
ARG_KERNEL_DEP="virtual/arg-kernel:="

# @FUNCTION: argent-kernel_check_arg_kernel
# @DESCRIPTION:
# Call this from pkg_postinst() of kernel module packages to notify users
# about arg-kernel tracking status. Prints an informational message when
# USE=arg-kernel is enabled, or a warning when virtual/arg-kernel is
# installed but USE=arg-kernel is not set for the package.
#
# Mirrors the behaviour of dist-kernel tracking in linux-mod-r1.eclass.
argent-kernel_check_arg_kernel() {
	if in_iuse arg-kernel && use arg-kernel; then
		einfo "This module is tracked for automatic rebuild on Argent kernel upgrades (USE=arg-kernel)."
	elif has_version "virtual/arg-kernel" && in_iuse arg-kernel && ! use arg-kernel; then
		ewarn "virtual/arg-kernel is installed, but USE=\"arg-kernel\""
		ewarn "is not enabled for ${CATEGORY}/${PN}."
		ewarn "It is recommended to globally enable the arg-kernel USE flag"
		ewarn "so that this module is automatically rebuilt on Argent kernel upgrades."
	fi
}

fi
