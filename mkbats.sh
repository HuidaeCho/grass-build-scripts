#!/bin/sh
# This script creates batch files for starting up GRASS GIS from MS Windows.
#
# Usage:
#	mkbats.sh c:/path/to/grass_root c:/python3/home

set -e

ARCH=x86_64-w64-mingw32
DIST=dist.$ARCH

if [ ! -e $DIST ]; then
	echo "$ARCH: Build this architecture first"
	exit 1
fi

if [ "$1" = "" ]; then
	echo "Specify c:/path/to/grass_root"
	exit 1
fi

if [ "$2" = "" ]; then
	echo "Specify python3 home"
	exit 1
fi

cp -a bin.$ARCH/grass79.py $DIST/etc
rm -f $DIST/grass79.tmp

GISBASE=`echo $1 | sed 's#/#\\\\\\\\#g'`
PYTHONHOME=`echo $2 | sed 's#/#\\\\\\\\#g'`

sed -e "s/@GISBASE@/$GISBASE/g" \
    -e "s/@PYTHONHOME@/$PYTHONHOME/g" \
    ../grass79.bat.tmpl > $DIST/grass79.bat
