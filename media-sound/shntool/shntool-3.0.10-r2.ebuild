# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit git-r3  ${GIT_ECLASS} autotools

DESCRIPTION="A multi-purpose WAVE data processing and reporting utility"
HOMEPAGE="https://github.com/flacon/shntool/"
EGIT_REPO_URI="https://github.com/flacon/shntool.git"
GIT_ECLASS="git-r3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="alac flac mac shorten sox wavpack"

RDEPEND="flac? ( media-libs/flac )
	mac? ( media-sound/mac )
	sox? ( media-sound/sox )
	alac? ( media-sound/alac_decoder )
	shorten? ( media-sound/shorten )
	wavpack? ( media-sound/wavpack )
"
DEPEND="${RDEPEND}"

DOCS="NEWS README ChangeLog AUTHORS doc/*"

src_configure() {
        export CONFIG_SHELL=${BASH}  # bug #527310
        default
}
