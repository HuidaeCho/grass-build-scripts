#!/bin/sh
# This script builds GRASS GIS addons for an architecture selected by switcharch.sh.
# It should be run from the root of the GRASS addon asource code.
#
# Usage:
#	myaddons.sh clean default

make \
MODULE_TOPDIR=$HOME/usr/grass/grass/dist.x86_64-pc-linux-gnu \
LIBREDWGLIBPATH=-L$HOME/usr/local/lib64 \
LIBREDWGINCPATH=-I$HOME/usr/local/include \
"$@" > myaddons.log 2>&1
