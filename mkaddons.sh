#!/bin/sh
# This script builds GRASS GIS addons for an architecture selected by switcharch.sh.
# It should be run from the root of the GRASS addon asource code.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_ADDONS_SRC/grass7

ARCH=`$GRASS_BUILD_DIR/switcharch.sh --query`

make \
MODULE_TOPDIR=$GRASS_SRC/dist.$ARCH \
LIBREDWGLIBPATH=-L$LIBREDWG_LIB \
LIBREDWGINCPATH=-I$LIBREDWG_INC \
"$@" > mkaddons.log 2>&1
