#!/bin/sh
# This script configures include/Make/Platform.make and other files for
# building GRASS GIS. It should be run from the root of the GRASS source code.
#
# Usage:
#	myconfigure.sh		# configure for native binaries
#	myconfigure.sh --mxe	# configure for x86_64-w64-mingw32 binaries
#				# using MXE

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

case "$1" in
""|-n|--native)
	CFLAGS="-g -O2 -Wall" \
	CXXFLAGS="-g -O2 -Wall" \
	LDFLAGS="-lcurses" \
	./configure \
	--with-nls \
	--with-readline \
	--with-wxwidgets \
	--with-freetype-includes=$FREETYPE_INC \
	--with-bzlib \
	--with-postgres \
	--with-pthread \
	--with-openmp \
	--with-blas \
	--with-lapack \
	--with-geos \
	--with-netcdf \
	--with-liblas \
	--with-pdal \
	> myconfigure.log 2>&1
	;;
-m|--mxe)
	arch=x86_64-w64-mingw32
	shared=$arch.shared
	mxe_bin=$MXE_DIR/usr/bin/$shared
	mxe_shared=$MXE_DIR/usr/$shared

	CC=$mxe_bin-gcc \
	CXX=$mxe_bin-g++ \
	CFLAGS="-g -O2 -Wall" \
	CXXFLAGS="-g -O2 -Wall" \
	AR=$mxe_bin-ar \
	RANLIB=$mxe_bin-ranlib \
	WINDRES=$mxe_bin-windres \
	PKG_CONFIG=$mxe_bin-pkg-config \
	./configure \
	--host=$arch \
	--with-nls \
	--with-readline \
	--with-wxwidgets \
	--with-freetype-includes=$mxe_shared/include/freetype2 \
	--with-bzlib \
	--with-postgres \
	--with-pthread \
	--with-openmp \
	--with-blas \
	--with-lapack \
	--with-geos=$mxe_shared/bin/geos-config \
	--with-netcdf=$mxe_shared/bin/nc-config \
	--with-gdal=$mxe_shared/bin/gdal-config \
	--with-opengl=windows \
	> myconfigure.log 2>&1
	;;
*)
	echo "$1: Architecture not supported"
	exit 1
	;;
esac

arch=`sed -n '/^ARCH[ \t]*=/{s/^.*=[ \t]*//; p}' include/Make/Platform.make`
for i in \
	myconfigure.log \
	config.log \
	include/Make/Platform.make \
	include/Make/Doxyfile_arch_html \
	include/Make/Doxyfile_arch_latex \
; do
	cp -a $i $i.$arch
done
