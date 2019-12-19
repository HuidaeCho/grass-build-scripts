#!/bin/sh
# This script copies document files from the native build to non-native builds.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

BUILD_ARCH=`sh ./config.guess`
BUILD_DIST=dist.$BUILD_ARCH

if [ ! -e $BUILD_DIST ]; then
	echo "$BUILD_ARCH: Build the native architecture first"
	exit 1
fi

for dist in dist.*; do
	test $dist = $BUILD_DIST && continue
	for i in \
		docs \
		gui/wxpython/xml \
	; do
		test -e $BUILD_DIST/$i || continue
		rm -rf $dist/$i
		cp -a $BUILD_DIST/$i $dist/$i
	done
done
