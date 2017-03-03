# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: da01b9c027706eece87170a04381093817940c7e $

EAPI="5"

if [[ ${PV} = 9999 ]]; then
        GIT_ECLASS="git-r3"
        EXPERIMENTAL="true"
fi

inherit cmake-utils eutils ${GIT_ECLASS}

DESCRIPTION="The DICOM Toolkit"
HOMEPAGE="http://dicom.offis.de/dcmtk.php.en"
#SRC_URI="ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk360/${P}.tar.gz"

EGIT_REPO_URI="git://git.dcmtk.org/dcmtk"


LICENSE="OFFIS"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE="doc png ssl tcpd tiff +threads xml zlib"

RDEPEND="
	virtual/jpeg:0
	png? ( media-libs/libpng:* )
	ssl? ( dev-libs/openssl:0 )
	tcpd? ( sys-apps/tcp-wrappers )
	tiff? ( media-libs/tiff:0 )
	xml? ( dev-libs/libxml2:2 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

#	media-gfx/graphviz"

#S="${WORKDIR}/${MY_P}"
#GIT_CHECKOUT_DIR=${S}

src_prepare() {
              true;

}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DBUILD_SHARED_LIBS=ON
                -DDCMTK_USE_CXX11_STL=YES
		-DCMAKE_INSTALL_PREFIX=/usr
		$(cmake-utils_use tiff DCMTK_WITH_TIFF)
		$(cmake-utils_use png DCMTK_WITH_PNG)
		$(cmake-utils_use xml DCMTK_WITH_XML)
		$(cmake-utils_use zlib DCMTK_WITH_ZLIB)
		$(cmake-utils_use ssl DCMTK_WITH_OPENSSL)
		$(cmake-utils_use doc DCMTK_WITH_DOXYGEN)
		$(cmake-utils_use threads DCMTK_WITH_THREADS)"

	cmake-utils_src_configure

	if use doc; then
		cd "${S}"/doxygen
		econf
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		emake -C "${S}"/doxygen || die
	fi
}

src_install() {
	cmake-utils_src_install

	doman doxygen/manpages/man1/* || die

	if use doc; then
		dohtml -r "${S}"/doxygen/htmldocs/* || die
	fi
}
