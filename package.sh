#!/bin/sh
# This script packages the cross-compiled GRASS GIS into a ZIP file for
# distribution.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

ARCH=x86_64-w64-mingw32
DIST=dist.$ARCH

if [ ! -e $DIST ]; then
	echo "$ARCH: Build this architecture first"
	exit 1
fi

VERSION=`sed -n '/^INST_DIR[ \t]*=/{s/^.*grass//; p}' include/Make/Platform.make`
DATE=`date +%Y%m%d`

rm -f grass
ln -s $DIST grass
rm -f grass*-$ARCH-*.zip
zip -r grass$VERSION-$ARCH-$DATE.zip grass
rm -f grass
