# Distributed under the terms of the GNU General Public License v2

EAPI="8"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://gitlab.com/argent/argentws-live.git"

inherit systemd git-r3

DESCRIPTION="Argent live scripts"
HOMEPAGE="http://www.rogentos.ro"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" SYSTEMD_UNITDIR="$(systemd_get_systemunitdir)" \
		install || die
}