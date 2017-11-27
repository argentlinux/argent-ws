# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit git-r3 toolchain-funcs golang-build

DESCRIPTION="Forked HTTP Request multiplexer from gorrila"
HOMEPAGE="https://github.com/stefancristian/mux"
SRC_URI=""

EGIT_REPO_URI="https://github.com/stefancristian/mux"

LICENSE="BSD-3"
SLOT="0"

if [[ ${PV} == *9999 ]];then
	KEYWORDS="~amd64"
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="v${PV}"
fi

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/go"

EGO_PN="github.com/stefancristian/mux"

DOCS=( README.md LICENSE )

go_arch()
{
    local portage_arch=$(tc-arch $@)
    case "${portage_arch}" in
        x86)    echo lib;;
        x64-*)  echo lib64;;
		amd64)	echo lib64;;
        *)      echo "${portage_arch}";;
    esac
}

GOPATH="${WORKDIR}/${P}:"${D}"/usr/$(go_arch)/go"

src_unpack() {
	golang_cleanup
	git-r3_src_unpack
	default
}

src_prepare() {
	eapply_user *.*
	mkdir -p "${WORKDIR}/${P}"/src/"${EGO_PN}" || die "Cannot create directory"
	cp -R *.go "${WORKDIR}/${P}"/src/"${EGO_PN}" || die "Cannot copy files and directories"
}

src_install() {
	golang-build_src_reinstall

	insinto /usr/$(go_arch)/go

	doins -r pkg
	doins -r src
	einstalldocs

	rm -rf "${D}"/usr/lib/ || die "There is no such path"
}
