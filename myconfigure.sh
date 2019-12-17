#!/bin/sh
set -e

case "$1" in
""|native)
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
	--with-freetype-includes=/usr/include/freetype2 \
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
mxe)
	ARCH=x86_64-w64-mingw32
	SHARED=$ARCH.shared
	MXE=$HOME/usr/local/src/mxe/usr/$SHARED

	CC=$SHARED-gcc \
	CXX=$SHARED-g++ \
	CFLAGS="-g -O2 -Wall" \
	CXXFLAGS="-g -O2 -Wall" \
	AR=$SHARED-ar \
	RANLIB=$SHARED-ranlib \
	WINDRES=$SHARED-windres \
	PKG_CONFIG=$SHARED-pkg-config \
	./configure \
	--host=$ARCH \
	--with-nls \
	--with-pthread \
	--with-blas \
	--with-lapack \
	--with-openmp \
	--with-postgres \
	--with-sqlite \
	--with-cairo-includes=$MXE/include/cairo \
	--with-freetype \
	--with-freetype-includes=$MXE/include/freetype2 \
	--with-readline \
	--with-python \
	--with-wxwidgets \
	--with-geos=$MXE/bin/geos-config \
	--with-netcdf=$MXE/bin/nc-config \
	--with-zstd \
	--with-bzlib \
	--with-gdal=$MXE/bin/gdal-config \
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
