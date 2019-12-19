#!/bin/sh
# This script builds GRASS GIS for an architecture selected by switcharch.sh.
# It should be run from the root of the GRASS source code.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

MAKE=include/Make/Platform.make

if [ ! -f $MAKE ]; then
	echo "No architecture configured"
	exit 1
fi

ARCH=`sed -n '/^ARCH[ \t]*=/{s/^.*=[ \]*//; p}' $MAKE`

make "$@" > mymake.log 2>&1

for i in \
	mymake.log \
	error.log \
; do
	cp -a $i $i.$ARCH
done
