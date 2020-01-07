#!/bin/sh
# This script builds GRASS GIS for an architecture selected by switcharch.sh.
# It should be run from the root of the GRASS source code.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

make=include/Make/Platform.make

if [ ! -f $make ]; then
	echo "No architecture configured"
	exit 1
fi

arch=`sed -n '/^ARCH[ \t]*=/{s/^.*=[ \]*//; p}' $make`

make "$@" > mymake.log 2>&1

for i in \
	mymake.log \
	error.log \
; do
	cp -a $i $i.$arch
done
