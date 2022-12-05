#!/bin/sh
# This script copies dependent DLLs from MXE. It requires pe-util.
#
# git clone --recurse-submodules git@github.com:gsauthof/pe-util.git
# mkdir pe-util/build
# cd pe-util/build
# cmake -DCMAKE_INSTALL_PREFIX=$HOME/usr/local ..
# make install

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

arch=x86_64-w64-mingw32
dist=dist.$arch
shared=$arch.shared
mxe_shared=$MXE_DIR/usr/$shared

if [ ! -d $dist ]; then
	echo "$arch: Build this architecture first"
	exit 1
fi

peldd --ignore-errors -a --no-path \
	--path $dist/lib \
	--path $mxe_shared/bin \
	$dist/lib/*.dll |
	sed '/\/mxe\//!d' |
	xargs -r cp -a -t $dist/lib

for i in \
	proj \
	gdal \
; do
	rm -rf $dist/share/$i
	cp -a $mxe_shared/share/$i $dist/share/$i
done
