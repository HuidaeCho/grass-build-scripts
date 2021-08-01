#!/bin/sh
# This script builds the native and cross-compilied versions of the GRASS GIS
# core, native GRASS addons, and gdal-grass plugins. Currently, the GRASS build
# scripts do not cross-compile GRASS addons and gdal-grass plugins.
#
# Usage:
#	update.sh	# update the native build only
#	update.sh --mxe	# update the native and cross-compiled builds

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

tmp=`realpath $0`; grass_build_scripts=`dirname $tmp`
PATH="$grass_build_scripts:$PATH"

(
cd $GRASS_SRC
merge.sh
myconfigure.sh
mymake.sh clean default

cd $GDAL_GRASS_SRC
myconfigure-gdal-grass.sh
make clean install

cd $GRASS_ADDONS_SRC
merge.sh
cd src
mkaddons.sh clean default

case "$1" in
-m|--mxe)
	cd $GRASS_SRC
	myconfigure.sh --mxe
	mymake.sh clean default
	copydocs.sh
	postcompile.sh
	package.sh
	switcharch.sh
	;;
esac
) > $GRASS_SRC/update.log 2>&1
