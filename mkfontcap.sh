#!/bin/sh
# This script generates etc/fontcap for the cross-compiled MinGW build.
#
# Usage:
#	mkfontcap.sh c:/path/to/grass_root

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

GISBASE=`echo $1 | sed 's#/#\\\\\\\\#g'`
sed "s/@GISBASE@/$GISBASE/g" ../fontcap.tmpl > $DIST/etc/fontcap
