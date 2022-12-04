#!/bin/sh
# This script packages the cross-compiled GRASS GIS into a ZIP file for
# distribution.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

arch=x86_64-w64-mingw32

if [ ! -d dist.$arch ]; then
	echo "$arch: Build this architecture first"
	exit 1
fi

version=`sed -n '/^INST_DIR[ \t]*=/{s/^.*grass//; p}' include/Make/Platform.make`
date=`date +%Y%m%d`

cp -a bin.$arch/grass.bat dist.$arch
rm -f grass
ln -s dist.$arch grass
rm -f grass*-$arch-*.zip
zip -r grass$version-$arch-$date.zip grass -x "*/__pycache__/*"
rm -f grass
