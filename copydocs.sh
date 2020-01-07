#!/bin/sh
# This script copies document files from the native build to non-native builds.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

build_arch=`sh ./config.guess`
build_dist=dist.$build_arch

if [ ! -d $build_dist ]; then
	echo "$build_arch: Build the native architecture first"
	exit 1
fi

for dist in dist.*; do
	test $dist = $build_dist && continue
	for i in \
		docs \
		gui/wxpython/xml \
	; do
		test -d $build_dist/$i || continue
		rm -rf $dist/$i
		cp -a $build_dist/$i $dist/$i
	done
done
