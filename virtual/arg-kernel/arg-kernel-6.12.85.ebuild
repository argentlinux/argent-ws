# Copyright 2024-2026 Argent
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual to depend on any Argent Linux kernel"
SLOT="0/${PVR}"
KEYWORDS="amd64 ~x86"

RDEPEND="
	~sys-kernel/linux-argent-${PV}
"
