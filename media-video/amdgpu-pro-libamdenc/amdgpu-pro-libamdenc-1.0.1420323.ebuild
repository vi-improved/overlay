# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

MY_PV_HIGH=$(ver_cut 1)
MY_PV_LOW=$(ver_cut 2)
MY_PV_REV=$(ver_cut 3)

MY_PV="${MY_PV_HIGH}.${MY_PV_LOW}"
MY_PV_FULL="${MY_PV}-${MY_PV_REV}"

MY_PN="libamdenc-amdgpu-pro"

PRO_VULKAN_PKG_VER="22.10.3"

DESCRIPTION="HEVC Encoder Library for AMDGPU PRO AMF"
HOMEPAGE="https://www.amd.com/en/support"
SRC_URI="https://repo.radeon.com/amdgpu/${PRO_VULKAN_PKG_VER}/ubuntu/pool/proprietary/liba/${MY_PN}/${MY_PN}_${MY_PV_FULL}_amd64.deb -> ${P}.deb"

S="${WORKDIR}"

RESTRICT="bindist mirror"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	media-libs/amdgpu-pro-vulkan
	media-libs/libglvnd
	x11-libs/libdrm
	x11-libs/libX11
"

QA_PREBUILT="
	usr/lib64/libamdenc64.so*
"

src_unpack() {
	mkdir "${S}/${PN}-amd64" || die
	cd "${S}/${PN}-amd64" || die
	unpack_deb "${DISTDIR}/${P}.deb"
}

src_install() {
	insinto "/usr/$(get_libdir)"

	# AMF
	doins "${S}/${PN}-amd64/opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdenc64.so.${MY_PV}"
	dosym "libamdenc64.so.${MY_PV}" "/usr/$(get_libdir)/libamdenc64.so.1"
	dosym "libamdenc64.so.${MY_PV}" "/usr/$(get_libdir)/libamdenc64.so"
}
