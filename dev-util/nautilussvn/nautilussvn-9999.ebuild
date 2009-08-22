# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2-utils subversion distutils

DESCRIPTION="Python subversion extension for Nautilus. TortoiseSVN clone"
HOMEPAGE="http://code.google.com/p/nautilussvn/"
ESVN_REPO_URI="http://nautilussvn.googlecode.com/svn/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="diff"

DEPEND=""
RDEPEND="dev-python/nautilus-python
		dev-python/configobj
		dev-python/pyinotify
		dev-python/pygtk
		dev-python/dbus-python
		dev-python/pysvn
		diff? ( dev-util/meld )"

src_unpack() {
	subversion_src_unpack
	has ${EAPI:-0} 0 1 && distutils_src_prepare

	# we should not do gtk-update-icon-cache from setup script
	# we prefer portage for that
	sed 's/"install"/"fakeinstall"/' -i "${S}/setup.py" \
		|| die "Can't update setup script"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_icon_cache_update

	elog "You should restart nautilus to changes take effect:"
	elog "$ nautilus -q && nautilus &"
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_icon_cache_update
}
