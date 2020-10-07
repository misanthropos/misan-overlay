# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = 9999 ]]; then
      GIT_ECLASS="git-r3"
      EXPERIMENTAL="true"
fi

inherit cmake ${GIT_ECLASS}


DESCRIPTION="A port of Jagged Alliance 2 to SDL2"
HOMEPAGE="https://github.com/ja2-stracciatella/"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/ja2-stracciatella/ja2-stracciatella.git"
else
	SRC_URI="https://github.com/ja2-stracciatella/ja2-stracciatella/releases/tag/v${PV}.tar.gz"
fi


LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdinstall editor zlib"


DEPEND="media-libs/libsdl2[X,sound,video]
	!=media-libs/libsdl2-2.0.6
        >=dev-lang/rust-1.40.0
        >=x11-libs/fltk-1.3.3-r3
        dev-util/cmake
	zlib? ( sys-libs/zlib )"

RDEPEND="${DEPEND}
	cdinstall? ( games-strategy/ja2-stracciatella-data )"

LANGS="linguas_de +linguas_en linguas_fr linguas_it linguas_nl linguas_pl linguas_ru linguas_ru_gold"

IUSE="$IUSE $LANGS"
REQUIRED_USE="^^ ( ${LANGS//+/} )"


src_configure() {
		local mycmakeargs=()

		case ${LINGUAS} in
			de) mycmakeargs+=" -DLNG=GERMAN" ;;
			nl) mycmakeargs+=" -DLNG=DUTCH" ;;
			fr) mycmakeargs+=" -DLNG=FRENCH" ;;
			it) mycmakeargs+=" -DLNG=ITALIAN" ;;
			pl) mycmakeargs+=" -DLNG=POLISH" ;;
			ru) mycmakeargs+=" -DLNG=RUSSIAN" ;;
			ru_gold) mycmakeargs+=" -DLNG=RUSSIAN_GOLD" ;;
			en) mycmakeargs+=" -DLNG=ENGLISH" ;;
			*) die "no language selected in LINGUAS" ;;
		esac
		   elog "Chosen language is ${mycmakeargs#LNG=}"

#		mycmakeargs+=" -DWITH_CUSTOM_LOCALE="
		mycmakeargs+=" -DWITH_ZLIB=$(usex zlib)"
		mycmakeargs+=" -DLOCAL_GTEST_LIB=OFF"
		mycmakeargs+=" -DLOCAL_RAPIDJSON_LIB=OFF"
        mycmakeargs+=" -DWITH_RUST_BINARIES=OFF"

		cmake_src_configure
}


src_compile() {
        cmake_src_compile 
}


src_install() {
	#dogamesbin ja2 "${T}"/ja2-convert

	if use editor; then
		insinto "${GAMES_DATADIR}"/ja2/data
		doins "${WORKDIR}"/editor.slf
	fi

	make_desktop_entry ja2 ${PN}

	prepgamesdirs
        cmake-utils_src_install
}

pkg_postinst() {
	games_pkg_postinst

	elog "You need ja2 in the chosen language, otherwise set it in package.use!"

	if ! use cdinstall ; then
		elog "You need to copy all files from the Data directory of"
		elog "Jagged Alliance 2 installation to"
		elog "${GAMES_DATADIR}/ja2/data "
		elog "Make sure the filenames are lowercase. You may want to run the"
		elog "script":
		elog "${GAMES_BINDIR}/ja2-convert"
	fi
}
