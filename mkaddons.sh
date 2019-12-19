#!/bin/sh
# This script builds GRASS GIS addons for the current architecture.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_ADDONS_SRC/grass7

ARCH=`$GRASS_BUILD_DIR/switcharch.sh --query`

make \
MODULE_TOPDIR=$GRASS_SRC/dist.$ARCH \
LIBREDWGLIBPATH=-L$LIBREDWG_LIB \
LIBREDWGINCPATH=-I$LIBREDWG_INC \
"$@" > mkaddons.log 2>&1

for i in \
	mkaddons.log \
	$GRASS_SRC/error.log \
; do
	cp -a $i $i.$ARCH
done
