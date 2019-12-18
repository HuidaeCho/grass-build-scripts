#!/bin/sh
# This script builds GRASS GIS addons for an architecture selected by switcharch.sh.
# It should be run from the root of the GRASS addon asource code.

set -e
. ~/.grassbuildrc
cd $GRASS_ADDONS_SRC/grass7

make \
MODULE_TOPDIR=$GRASS_SRC/dist.x86_64-pc-linux-gnu \
LIBREDWGLIBPATH=-L$LIBREDWG_LIB \
LIBREDWGINCPATH=-I$LIBREDWG_INC \
"$@" > myaddons.log 2>&1
