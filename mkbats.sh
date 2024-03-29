#!/bin/sh
# This script creates a batch file for starting up GRASS GIS from the
# source directory.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

arch=x86_64-w64-mingw32
version=`sed -n '/^INST_DIR[ \t]*=/{s/^.*grass//; p}' include/Make/Platform.make`
scripts=$(dirname $(realpath $0))

rm -f bin.$arch/grass dist.$arch/grass.tmp
[ -f bin.$arch/grass.py ] && mv bin.$arch/grass.py dist.$arch/etc/grass$version.py
unix2dos -n $scripts/grass.bat bin.$arch/grass.bat
unix2dos -n $scripts/sh.bat dist.$arch/etc/sh.bat

if wget -O dist.$arch/etc/busybox64.exe https://frippery.org/files/busybox/busybox64.exe; then
	cp -a dist.$arch/etc/busybox64.exe .
else
	cp -a busybox64.exe dist.$arch/etc
fi
