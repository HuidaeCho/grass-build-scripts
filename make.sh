#!/bin/sh
# This script builds GRASS GIS or addons for an architecture selected by
# switcharch.sh, or gdal-grass for the currently configured architecture.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

grass_build_scripts=$(dirname $(realpath $0))
arch=`$grass_build_scripts/switcharch.sh --query`

opt=$1
shift

case "$opt" in
-h|--help)
	cat<<'EOT'
Usage: make.sh [OPTIONS]

-h, --help      display this help message
    --addons    make addons (default: GRASS)
    --addon     make an addon
    --gdal      make gdal-grass
EOT
	exit
	;;
"")
	cd $GRASS_SRC
	make "$@"
	;;
--addons|--addon)
	test "$opt" = "--addons" && cd $GRASS_ADDONS_SRC/src
	make \
	MODULE_TOPDIR=$GRASS_SRC \
	LIBREDWGLIBPATH=-L$LIBREDWG_LIB \
	LIBREDWGINCPATH=-I$LIBREDWG_INC \
	"$@"
	;;
--gdal)
	cd $GDAL_GRASS_SRC
	make "$@"
	;;
*)
	echo "$opt: Unknown option"
	exit 1
esac

if [ "$opt" != "--gdal" ]; then
	cd $GRASS_SRC
	for i in \
		error.log \
	; do
		cp -a $i $i.$arch
	done
fi
