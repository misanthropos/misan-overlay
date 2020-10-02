# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_7 )

inherit python-single-r1 autotools gnome2

DESCRIPTION="A password manager for GNOME"
HOMEPAGE="https://revelation.olasagasti.info/"
SRC_URI="https://github.com/mikelolasagasti/revelation/releases/download/${P}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pycryptodomex[${PYTHON_MULTI_USEDEP}]
                dev-python/pygobject[${PYTHON_MULTI_USEDEP}]
                dev-libs/libpwquality[${PYTHON_MULTI_USEDEP}]
	')
        x11-libs/gtk+
"

DEPEND="${RDEPEND}"

src_prepare() {
#	epatch "${FILESDIR}/${P}-random.patch" \
#		   "${FILESDIR}/${P}-xor.patch" \
#		   "${FILESDIR}/${P}-gnome-python.patch"
	eapply_user
	eautoreconf
}

src_configure() {
	gnome2_src_configure \
		--disable-desktop-update \
		--disable-mime-update
}

src_install() {
	gnome2_src_install
	python_fix_shebang "${ED}"
}
