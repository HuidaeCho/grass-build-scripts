#!/bin/sh
# This script builds a GRASS GIS addon for the current architecture. It should
# be run from the source directory of a GRASS addon.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

grass_build_scripts=$(dirname $(realpath $0))
arch=`$grass_build_scripts/switcharch.sh --query`

make \
MODULE_TOPDIR=$GRASS_SRC \
LIBREDWGLIBPATH=-L$LIBREDWG_LIB \
LIBREDWGINCPATH=-I$LIBREDWG_INC \
"$@"
