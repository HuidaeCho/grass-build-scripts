#!/bin/sh
# This script configures include/Make/Platform.make and other files for
# building GRASS GIS. It should be run from the root of the GRASS source code.
#
# Usage:
#	myconfigure.sh		# for compiling native binaries
#	myconfigure.sh --mxe	# for cross-compiling x86_64-w64-mingw32
#				# binaries using MXE

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
	--with-cxx \
	--with-pthread \
	--with-blas \
	--with-lapack \
	--with-openmp \
	--with-postgres \
	--with-sqlite \
	--with-motif \
	--with-freetype \
	--with-freetype-includes=$FREETYPE_INC \
	--with-readline \
	--with-python \
	--with-wxwidgets \
	--with-geos \
	--with-netcdf \
	--with-zstd \
	--with-liblas \
	--with-bzlib \
	--with-pdal \
	> myconfigure.log 2>&1
	;;
-m|--mxe)
	ARCH=x86_64-w64-mingw32
	SHARED=$ARCH.shared
	MXE_BIN=$MXE_SRC/usr/bin/$SHARED
	MXE_SHARED=$MXE_SRC/usr/$SHARED

	CC=$MXE_BIN-gcc \
	CXX=$MXE_BIN-g++ \
	CFLAGS="-g -O2 -Wall" \
	CXXFLAGS="-g -O2 -Wall" \
	AR=$MXE_BIN-ar \
	RANLIB=$MXE_BIN-ranlib \
	WINDRES=$MXE_BIN-windres \
	PKG_CONFIG=$MXE_BIN-pkg-config \
	./configure \
	--host=$ARCH \
	--with-nls \
	--with-pthread \
	--with-blas \
	--with-lapack \
	--with-openmp \
	--with-postgres \
	--with-sqlite \
	--with-cairo-includes=$MXE_SHARED/include/cairo \
	--with-freetype \
	--with-freetype-includes=$MXE_SHARED/include/freetype2 \
	--with-readline \
	--with-python \
	--with-wxwidgets \
	--with-geos=$MXE_SHARED/bin/geos-config \
	--with-netcdf=$MXE_SHARED/bin/nc-config \
	--with-zstd \
	--with-bzlib \
	--with-gdal=$MXE_SHARED/bin/gdal-config \
	--with-opengl=windows \
	> myconfigure.log 2>&1
	;;
*)
	echo "$1: Architecture not supported"
	exit 1
	;;
esac

ARCH=`sed -n '/^ARCH[ \t]*=/{s/^.*=[ \]*//; p}' include/Make/Platform.make`
for i in \
	myconfigure.log \
	config.log \
	include/Make/Platform.make \
	include/Make/Doxyfile_arch_html \
	include/Make/Doxyfile_arch_latex \
; do
	cp -a $i $i.$ARCH
done
