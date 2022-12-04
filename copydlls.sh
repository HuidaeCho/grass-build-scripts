#!/bin/sh
# This script copies dependent DLLs from MXE.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

arch=x86_64-w64-mingw32
dist=dist.$arch
shared=$arch.shared
mxe_shared=$MXE_DIR/usr/$shared

if [ ! -d $dist ]; then
	echo "$arch: Build this architecture first"
	exit 1
fi

for i in \
	libblas.dll \
	libbz2.dll \
	libcairo-2.dll \
	libcrypto-3-x64.dll \
	libcurl-4.dll \
	libdf-0.dll \
	libexpat-1.dll \
	libfftw3-3.dll \
	libfontconfig-1.dll \
	libfreetype-6.dll \
	libfreexl-1.dll \
	libgcc_s_seh-1.dll \
	libgcrypt-20.dll \
	libgdal-20.dll \
	libgeos-3-9-1.dll \
	libgeos_c-1.dll \
	libgeotiff-2.dll \
	libgfortran-5.dll \
	libgif-7.dll \
	libglib-2.0-0.dll \
	libgnurx-0.dll \
	libgomp-1.dll \
	libgpg-error-0.dll \
	libgta-0.dll \
	libharfbuzz-0.dll \
	libhdf5-8.dll \
	libhdf5_hl-8.dll \
	libiconv-2.dll \
	libidn2-0.dll \
	libintl-8.dll \
	libjpeg-9.dll \
	libjson-c-4.dll \
	liblapack.dll \
	liblzma-5.dll \
	libmfhdf-0.dll \
	libmysqlclient.dll \
	libnetcdf.dll \
	libopenjp2.dll \
	libpcre-1.dll \
	libpixman-1-0.dll \
	libpng16-16.dll \
	libportablexdr-0.dll \
	libpq.dll \
	libproj-13.dll \
	libquadmath-0.dll \
	libreadline8.dll \
	libspatialite-7.dll \
	libsqlite3-0.dll \
	libssh2-1.dll \
	libssl-3-x64.dll \
	libstdc++-6.dll \
	libtermcap.dll \
	libtiff-5.dll \
	libunistring-2.dll \
	libwebp-7.dll \
	libwinpthread-1.dll \
	libxml2-2.dll \
	libzstd.dll \
	zlib1.dll \
; do
	cp -a $mxe_shared/bin/$i $dist/lib
done

for i in \
	proj \
	gdal \
; do
	rm -rf $dist/share/$i
	cp -a $mxe_shared/share/$i $dist/share/$i
done
