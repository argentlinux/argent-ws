EAPI=8

DESCRIPTION="OpenPGP keys used by Argent Linux for repositories and binary packages"
HOMEPAGE="https://argentlinux.io"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		|| (
			app-crypt/gnupg[alternatives(-)]
			>=app-crypt/freepg-2.5.12_p1-r1
		)
	)
"

# Generated with:
# 1. export GNUPGHOME=<the offline Argent keyring>
# 2. gpg --armor --export B0CC3F7C7C097B35383B753D2F78FA0548873567 > argent.asc.${PV}
# 3. Verify gpg --show-keys --with-subkey-fingerprints argent.asc.${PV} shows
#    only the keys listed below, and no secret key material
# 4. Compare gpg --show-keys of the previous version with the new one, make
#    sure the changes look expected
#
# Keys included:
# B0CC3F7C7C097B35383B753D2F78FA0548873567 primary, certify only
# 5485D6F2EDE3E63FF68BF5039039C45ABB6FDB45 signing subkey, binary packages
# ED7D9C6AF0606E8CE0E04AF6744AEDDFFA7F48CA signing subkey, git commits
#
# Test signatures (files/argent-test-sigs-20261004), one per signing subkey:
# gpg --armor --local-user "<subkey fingerprint>!" --detach-sign <role>.txt

src_test() {
	local old_umask=$(umask)
	umask 077

	local -x GNUPGHOME=${T}/.gnupg
	mkdir "${GNUPGHOME}" || die
	einfo "Importing keys ..."
	gpg-reference --import "${FILESDIR}"/argent.asc.${PV} || die "Key import failed"

	local f sigs=( "${FILESDIR}"/argent-test-sigs-20261004/*.asc )
	[[ -e ${sigs[0]} ]] || die "No test signatures found in ${FILESDIR}/argent-test-sigs-20261004"
	for f in "${sigs[@]}"; do
		einfo "Testing ${f##*/} ..."
		gpg-reference -q --trust-model always --verify "${f}" "${f%.asc}" || die "Verification failed on ${f}"
	done

	umask "${old_umask}"
}

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${FILESDIR}"/argent.asc.${PV} argent.asc
}
