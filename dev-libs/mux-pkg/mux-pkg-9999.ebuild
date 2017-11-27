# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit git-r3 golang-build

DESCRIPTION="Forked HTTP Request multiplexer from gorrila"
HOMEPAGE="https://github.com/stefancristian/mux"
SRC_URI=""

EGIT_REPO_URI="https://github.com/stefancristian/mux"

LICENSE="BSD-3"
SLOT="0"

if [[ ${PV} == *9999 ]];then
	KEYWORDS="amd64"
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="v${PV}"
fi

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/go
	dev-libs/mux-src"

EGO_PN="mux-src"

src_unpack() {
	git-r3_src_unpack
	default
}

#src_install() {
#	cd ${T}
#	cd $(ls | grep go-build*)
#	insinto /usr/lib/go/pkg/linux_amd64/mux-pkg/
#	doins mux-src.a
#}
