#!/bin/sh
# This script builds GRASS GIS or addons for an architecture selected by
# switcharch.sh, or gdal-grass for the currently configured architecture.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

arch=`$(dirname $(realpath $0))/switcharch.sh --query`

case "$1" in
-h|--help)
	cat<<'EOT'
Usage: make.sh [OPTIONS] [TARGETS]

-h, --help      display this help message
-a, --addons    make addons (default: GRASS)
-A, --addon     make an addon
-g, --gdal      make gdal-grass
EOT
	exit
	;;
-a|--addons)
	opt="addons"
	shift
	;;
-A|--addon)
	opt="addon"
	shift
	;;
-g|--gdal)
	opt="gdal"
	shift
	;;
-*)
	echo "$1: Unknown option"
	exit 1
	;;
*)
	opt=""
	;;
esac

case "$opt" in
"")
	cd $GRASS_SRC
	make "$@"
	;;
-a|-A|--addons|--addon)
	[ "$opt" = "addons" ] && cd $GRASS_ADDONS_SRC/src
	make \
	MODULE_TOPDIR=$GRASS_SRC \
	LIBREDWGLIBPATH=-L$LIBREDWG_LIB \
	LIBREDWGINCPATH=-I$LIBREDWG_INC \
	"$@"
	;;
-g|--gdal)
	cd $GDAL_GRASS_SRC
	make "$@"
	;;
esac

if [ "$opt" != "gdal" ]; then
	cd $GRASS_SRC
	for i in \
		error.log \
	; do
		cp -a $i $i.$arch
	done
fi
