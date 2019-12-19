#!/bin/sh
# This script builds a GRASS GIS addon for an architecture selected by switcharch.sh.
# It should be run from the root of the GRASS addon asource code.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

ARCH=`$GRASS_BUILD_DIR/switcharch.sh --query`

make \
MODULE_TOPDIR=$GRASS_SRC/dist.$ARCH \
LIBREDWGLIBPATH=-L$LIBREDWG_LIB \
LIBREDWGINCPATH=-I$LIBREDWG_INC \
"$@" > mkaddon.log 2>&1
