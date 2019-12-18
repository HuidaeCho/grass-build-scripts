#!/bin/sh
# This script packages the cross-compiled GRASS GIS into a ZIP file for
# distribution.

set -e
. ~/.grassbuildrc
cd $GRASS_SRC

ARCH=x86_64-w64-mingw32
DIST=dist.$ARCH

if [ ! -e $DIST ]; then
	echo "$ARCH: Build this architecture first"
	exit 1
fi

DATE=`date +%Y%m%d`

rm -f grass
ln -s $DIST grass
zip -r $GRASS_ZIP_DIR/grass-$ARCH-$DATE.zip grass
