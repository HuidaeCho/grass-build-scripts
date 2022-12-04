#!/bin/sh
# This script builds GRASS GIS for an architecture selected by switcharch.sh.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

make=include/Make/Platform.make

if [ ! -f $make ]; then
	echo "No architecture configured"
	exit 1
fi

arch=`sed -n '/^ARCH[ \t]*=/{s/^.*=[ \]*//; p}' $make`

make "$@"

for i in \
	error.log \
; do
	cp -a $i $i.$arch
done
