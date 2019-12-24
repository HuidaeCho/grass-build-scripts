#!/bin/sh
# This script builds a GRASS GIS addon for the current architecture. It should
# be run from the source directory of a GRASS addon.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

tmp=`dirname $0`; GRASS_BUILD_SCRIPTS=`realpath $tmp`
ARCH=`$GRASS_BUILD_SCRIPTS/switcharch.sh --query`

make \
MODULE_TOPDIR=$GRASS_SRC/dist.$ARCH \
LIBREDWGLIBPATH=-L$LIBREDWG_LIB \
LIBREDWGINCPATH=-I$LIBREDWG_INC \
"$@"
