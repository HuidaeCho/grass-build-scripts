#!/bin/sh
# This script builds GRASS GIS addons for the current architecture.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_ADDONS_SRC/src

grass_build_scripts=$(dirname $(realpath $0))
arch=`$grass_build_scripts/switcharch.sh --query`

make \
MODULE_TOPDIR=$GRASS_SRC \
LIBREDWGLIBPATH=-L$LIBREDWG_LIB \
LIBREDWGINCPATH=-I$LIBREDWG_INC \
"$@"

cd $GRASS_SRC
for i in \
	error.log \
; do
	cp -a $i $i.$arch
done
