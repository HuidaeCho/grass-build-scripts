#!/bin/sh
#
# Purpose: Script for building a cross-compiled portable package of GRASS GIS
#          based on https://github.com/HuidaeCho/grass-build-scripts
#
# Author:  Huidae Cho
#
# Requires MXE <https://mxe.cc/> for cross-compilation
#
# Tested on Slackware 14.2 x86_64 with up-to-date packages from slackpkg and
# sbopkg
#
# Basic Steps:
#
# mkdir -p ~/usr/src
# cd ~/usr/src
# git clone https://github.com/mxe/mxe.git
# cd mxe
# echo MXE_TARGETS=x86_64-w64-mingw32.shared > settings.mk
# make cc blas bzip2 cairo fftw freetype gdal geos lapack netcdf libpng \
#      pthreads readline libgnurx sqlite tiff zstd proj
#
# cd ~/usr/src
# git clone https://github.com/OSGeo/grass.git
# cd grass
# MXE_SRC=$HOME/usr/src/mxe cross_compile.sh > cross_compile.log 2>&1
#

################################################################################
# Initialization

# Stop on errors
set -e

# Default paths, but can be overriden from the command line
MXE_SRC=${MXE_SRC-$HOME/usr/local/src/mxe}
FREETYPE_INC=${FREETYPE_INC-/usr/include/freetype2}

# See if we're inside the root of the GRASS source code
if [ ! -e grass.pc.in ]; then
	echo "Please run this script from the root of the GRASS source code"
	exit 1
fi

# Check paths
CMD=
VARS=
if [ ! -e $MXE_SRC ]; then
	echo "$MXE_SRC: not found"
	CMD="$CMD MXE_SRC=/opt/mxe"
	VARS="$VARS \$MXE_SRC"
fi
if [ ! -e $FREETYPE_INC ]; then
	echo "$FREETYPE_INC: not found"
	CMD="$CMD FREETYPE_INC=/usr/local/include/freetype2"
	VARS="$VARS \$FREETYPE_INC"
fi
if [ -n "$CMD" ]; then
	echo
	echo "Please override$VARS; for example,"
	echo $CMD cross_compile.sh
	exit 1
fi

################################################################################
# Compile the native architecture for generating document files

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
> /dev/stdout

make clean default

BUILD_ARCH=`sed -n '/^ARCH[ \t]*=/{s/^.*=[ \]*//; p}' include/Make/Platform.make`
for i in \
	config.log \
	include/Make/Platform.make \
	include/Make/Doxyfile_arch_html \
	include/Make/Doxyfile_arch_latex \
	error.log \
; do
	test -e $i && cp -a $i $i.$BUILD_ARCH
done

################################################################################
# Cross-compile the target architecture

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
> /dev/stdout

make clean default

ARCH=`sed -n '/^ARCH[ \t]*=/{s/^.*=[ \]*//; p}' include/Make/Platform.make`
for i in \
	config.log \
	include/Make/Platform.make \
	include/Make/Doxyfile_arch_html \
	include/Make/Doxyfile_arch_latex \
	error.log \
; do
	test -e $i && cp -a $i $i.$BUILD_ARCH
done

################################################################################
# Copy document files from the native build

BUILD_DIST=dist.$BUILD_ARCH
DIST=dist.$ARCH

for i in \
	docs \
	gui/wxpython/xml \
; do
	test -e $BUILD_DIST/$i || continue
	rm -rf $DIST/$i
	cp -a $BUILD_DIST/$i $DIST/$i
done

################################################################################
# Copy MXE files

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
	cp -a $MXE_SHARED/bin/$i $DIST/lib
done

for i in \
	proj \
	gdal \
; do
	test -e $DIST/share/$i && rm -rf $DIST/share/$i
	cp -a $MXE_SHARED/share/$i $DIST/share
done

################################################################################
# Prepare portable start-up

VERSION=`sed -n '/^INST_DIR/{s/^INST_DIR.*grass//; p}' include/Make/Platform.make`

rm -f $DIST/grass$VERSION.tmp
cp -a bin.$ARCH/grass$VERSION.py $DIST/etc

cat<<'EOT' > $DIST/grass$VERSION.bat
@echo off

rem Change this variable to override auto-detection of python.exe in PATH
set GRASS_PYTHON=C:\Python38\python.exe

rem For portable installation, use %~d0 for the changing drive letter
rem set GRASS_PYTHON=%~d0\Python38\python.exe

set GISBASE=%~dp0
set GRASS_PROJSHARE=%GISBASE%\share\proj

set PROJ_LIB=%GISBASE%\share\proj
set GDAL_DATA=%GISBASE%\share\gdal

rem XXX: Do we need these variables?
rem set GEOTIFF_CSV=%GISBASE%\share\epsg_csv
rem set FONTCONFIG_FILE=%GISBASE%\etc\fonts.conf

if not exist %GISBASE%\etc\fontcap (
	pushd .
	set GISRC=dummy
	cd %GISBASE%\lib
	%GISBASE%\bin\g.mkfontcap.exe
	popd
)

if not exist "%GRASS_PYTHON%" (
	set GRASS_PYTHON=
	for /f usebackq %%i in (`where python.exe`) do set GRASS_PYTHON=%%i
)
if "%GRASS_PYTHON%"=="" (
	echo.
	echo python.exe not found in PATH
	echo Please set GRASS_PYTHON in %~f0
	echo.
	pause
	goto:eof
)
rem XXX: Do we need PYTHONHOME?
rem for %%i in (%GRASS_PYTHON%) do set PYTHONHOME=%%~dpi

"%GRASS_PYTHON%" "%GISBASE%\etc\grass79.py" %*
if %ERRORLEVEL% geq 1 pause
EOT
unix2dos $DIST/grass$VERSION.bat

################################################################################
# Package

DATE=`date +%Y%m%d`

rm -f grass
ln -s $DIST grass
rm -f grass*-$ARCH-*.zip
zip -r grass$VERSION-$ARCH-$DATE.zip grass
rm -f grass
