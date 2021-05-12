# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.13.0
adler-0.2.3
aho-corasick-0.7.13
android_log-sys-0.2.0
android_logger-0.9.0
ansi_term-0.11.0
arrayref-0.3.6
arrayvec-0.5.1
ascii-0.9.3
atty-0.2.14
autocfg-1.0.1
backtrace-0.3.50
base64-0.12.3
bitflags-1.2.1
blake2b_simd-0.5.10
block-buffer-0.7.3
block-padding-0.1.5
byte-tools-0.3.1
byteorder-1.3.4
caseless-0.2.1
cbindgen-0.13.2
cesu8-1.1.0
cfg-if-0.1.10
chrono-0.4.15
clap-2.33.3
combine-3.8.1
constant_time_eq-0.1.5
crossbeam-channel-0.4.4
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-utils-0.7.2
derivative-2.1.1
digest-0.8.1
dirs-1.0.5
dunce-1.0.1
either-1.6.1
env_logger-0.7.1
error-chain-0.12.4
generic-array-0.12.3
getopts-0.2.21
getrandom-0.1.15
gimli-0.22.0
hashbrown-0.9.0
hermit-abi-0.1.15
hex-0.3.2
indexmap-1.6.0
itoa-0.4.6
jni-0.14.0
jni-sys-0.3.0
json_comments-0.2.0
lazy_static-1.4.0
libc-0.2.77
log-0.4.11
maybe-uninit-2.0.0
md-5-0.8.0
memchr-2.3.3
memoffset-0.5.5
miniz_oxide-0.4.2
ndk-0.2.0
ndk-sys-0.2.0
num-integer-0.1.43
num-traits-0.2.12
num_cpus-1.13.0
num_enum-0.4.3
num_enum_derive-0.4.3
object-0.20.0
opaque-debug-0.2.3
ppv-lite86-0.2.9
proc-macro-crate-0.1.5
proc-macro2-1.0.21
quote-1.0.7
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
rayon-1.4.0
rayon-core-1.8.0
redox_syscall-0.1.57
redox_users-0.3.5
regex-1.3.9
regex-syntax-0.6.18
remove_dir_all-0.5.3
rust-argon2-0.8.2
rustc-demangle-0.1.16
ryu-1.0.5
same-file-1.0.6
scopeguard-1.1.0
serde-1.0.116
serde_derive-1.0.116
serde_json-1.0.57
simplelog-0.6.0
strsim-0.8.0
syn-1.0.41
tempfile-3.1.0
term-0.5.2
textwrap-0.11.0
thiserror-1.0.20
thiserror-impl-1.0.20
thread_local-1.0.1
time-0.1.44
tinyvec-0.3.4
toml-0.5.6
typenum-1.12.0
unicode-normalization-0.1.13
unicode-width-0.1.8
unicode-xid-0.2.1
unreachable-1.0.0
vec_map-0.8.2
version_check-0.9.2
void-1.0.2
walkdir-2.3.1
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo cmake xdg

DESCRIPTION="An improved, cross-platform, stable Jagged Alliance 2 runtime"
HOMEPAGE="https://github.com/ja2-stracciatella/"
SRC_URI="https://github.com/ja2-stracciatella/ja2-stracciatella/archive/v${PV}.tar.gz -> ${P}.tar.gz
	editor? ( https://github.com/ja2-stracciatella/free-ja2-resources/releases/download/v1/editor.slf -> ${P}-editor.slf )
"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"

LICENSE="public-domain SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="cdinstall editor ru-gold test"
# Run with ja2 --unittest
# Needs data files?
RESTRICT="test"
#RESTRICT="!test? ( test )"

DEPEND="
	media-libs/libsdl2[X,sound,video]
	!~media-libs/libsdl2-2.0.6
	>=virtual/rust-1.40.0
	>=x11-libs/fltk-1.3.5[opengl]
	>=dev-cpp/string-theory-3.1
	>=dev-games/libsmacker-1.1.1
	>=dev-libs/rapidjson-1.1.0
"
RDEPEND="
	${DEPEND}
	cdinstall? ( games-strategy/ja2-stracciatella-data )
"
DEPEND+="test? ( >=dev-cpp/gtest-1.9.0_pre20190607 )"

LANGS="l10n_de +l10n_en l10n_fr l10n_it l10n_nl l10n_pl l10n_ru"

IUSE="$IUSE $LANGS"
REQUIRED_USE="^^ ( ${LANGS//+/} )"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
		local mycmakeargs=()

		case ${L10N} in
			de) mycmakeargs+=" -DLNG=GERMAN" ;;
			nl) mycmakeargs+=" -DLNG=DUTCH" ;;
			fr) mycmakeargs+=" -DLNG=FRENCH" ;;
			it) mycmakeargs+=" -DLNG=ITALIAN" ;;
			pl) mycmakeargs+=" -DLNG=POLISH" ;;
			ru) mycmakeargs+=" -DLNG=$(usex ru-gold RUSSIAN_GOLD RUSSIAN)" ;;
			en) mycmakeargs+=" -DLNG=ENGLISH" ;;
			*) die "no language selected in L10N" ;;
		esac
		elog "Chosen language is ${mycmakeargs# -DLNG=}"

		mycmakeargs+=(
			-DLOCAL_GTEST_LIB=OFF
			-DLOCAL_RAPIDJSON_LIB=OFF
			-DLOCAL_STRING_THEORY_LIB=OFF
			-DWITH_UNITTESTS=$(usex test)
			-DWITH_RUST_BINARIES=OFF
			-DBUILD_LAUNCHER=OFF
			-DOPENGL_GL_PREFERENCE=GLVND
			-DINSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
			-DEXTRA_DATA_DIR="${EPREFIX}/usr/share/ja2"
		)

		cargo_gen_config
		cmake_src_configure
}

src_install() {
	if use editor; then
		insinto /usr/share/ja2
		doins "${DISTDIR}/${P}-editor.slf"
		dosym "${P}-editor.slf" "/usr/share/ja2/editor.slf"
	fi

	cmake_src_install
}

pkg_postinst() {
	elog "You need ja2 in the chosen language, otherwise set it in package.use!"

	if ! use cdinstall ; then
		elog "You need to copy all files from the Data directory of"
		elog "Jagged Alliance 2 installation to"
		elog "e.g. /opt/ja2/data and set game_dir in .ja2/ja2.json"
		elog "accordingly."
		elog "Make sure the filenames are lowercase."
	fi

	xdg_pkg_postinst
}
