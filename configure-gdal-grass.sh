#!/bin/sh
# This script configures gdal-grass plugins.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GDAL_GRASS_SRC

case "$1" in
-h|--help)
	cat<<'EOT'
Usage: configure-gdal-grass.sh [OPTIONS]

-h, --help    display this help message
    --mxe     configure for x86_64-w64-mingw32 binaries using MXE
	      (default: configure for native binaries)
EOT
	;;
""|--native)
	CXX="g++ -std=c++11" \
	./configure \
	--with-grass=$GRASS_SRC/dist.x86_64-pc-linux-gnu \
	--with-autoload=$GDAL_PLUGINS_DIR
	;;
--mxe)
	build_arch=x86_64-pc-linux-gnu
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
	--with-grass=$GRASS_SRC/dist.x86_64-pc-linux-gnu \
	--with-autoload=$GDAL_PLUGINS_DIR
	;;
*)
	echo "$1: Architecture not supported"
	exit 1
	;;
esac
