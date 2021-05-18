# Distributed under the terms of the GNU General Public License v2
# Maintainer BlackNoxis <stefan.cristian at rogentos.ro>

EAPI=6

inherit git-r3 eutils

DESCRIPTION="Argent-Linux GRUB2 Images"
HOMEPAGE="http://www.rogentos.ro"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://gitlab.com/argent/boot-core.git"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE=""
RDEPEND=""

S="${WORKDIR}"

src_install () {
	dodir /usr/share/grub/themes || die
	insinto /usr/share/grub/themes || die
	doins -r "${S}"/cdroot/boot/grub/themes/argent || die
}
