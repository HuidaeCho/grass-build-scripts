#!/bin/sh
# This script packages the cross-compiled GRASS GIS into a ZIP file for
# distribution.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

arch=x86_64-w64-mingw32
dist=DIST.$arch

if [ ! -d $dist ]; then
	echo "$arch: Build this architecture first"
	exit 1
fi

version=`sed -n '/^INST_DIR[ \t]*=/{s/^.*grass//; p}' include/Make/Platform.make`
date=`date +%Y%m%d`

rm -f grass
ln -s $dist grass
rm -f grass*-$arch-*.zip
zip -r grass$version-$arch-$date.zip grass
rm -f grass
