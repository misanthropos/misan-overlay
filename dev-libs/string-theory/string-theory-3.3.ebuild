# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = 9999 ]]; then
      GIT_ECLASS="git-r3"
      EXPERIMENTAL="true"
fi

inherit cmake ${GIT_ECLASS}

DESCRIPTION="String Theory is a flexible modern C++ library for string manipulation and storage"
HOMEPAGE="https://github.com/zrax/string_theory/"

SRC_URI="https://github.com/zrax/string_theory/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/string_theory-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"


src_configure() {
		cmake_src_configure
}

src_compile() {
		cmake_src_compile 
}

src_install() {
		cmake_src_install
}
