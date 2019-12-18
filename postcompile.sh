#!/bin/sh
# This script post-processes the cross-compiled MinGW build for starting up
# GRASS GIS from MS Windows.

set -e
. ~/.grassbuildrc
cd $GRASS_SRC

ARCH=x86_64-w64-mingw32
DIST=dist.$ARCH
SHARED=$ARCH.shared
MXE=$MXE_SRC/usr/$SHARED

if [ ! -e $DIST ]; then
	echo "$ARCH: Build this architecture first"
	exit 1
fi

PYTHONHOME=`echo $PYTHON_WINDIR | sed 's#/#\\\\#g; s#\\\\#\\\\\\\\#g'`

for i in \
	libblas.dll \
	libbz2.dll \
	libcairo-2.dll \
	libcrypto-1_1-x64.dll \
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
	libgeos-3-6-2.dll \
	libgeos_c-1.dll \
	libgeotiff-2.dll \
	libgfortran-3.dll \
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
	libssl-1_1-x64.dll \
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
	cp -a $MXE/bin/$i $DIST/lib
done

for i in \
	proj \
	gdal \
; do
	test -e $DIST/share/$i && rm -rf $DIST/share/$i
	cp -a $MXE/share/$i $DIST/share
done

cp -a bin.$ARCH/grass79.py $DIST/etc
rm -f $DIST/grass79.tmp

sed "s/@PYTHONHOME@/$PYTHONHOME/g" $GRASS_BUILD_DIR/grass79.bat.tmpl > $DIST/grass79.bat
