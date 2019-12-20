#!/bin/sh
# This script builds the native and cross-compilied versions of the GRASS GIS
# core, native GRASS addons, and gdal-grass plugins. Currently, the GRASS build
# scripts do not cross-compile GRASS addons and gdal-grass plugins.
#
# Usage:
#	update.sh	# for updating the native build only
#	update.sh --mxe	# for updating the native and cross-compiled builds

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

PATH="$GRASS_BUILD_DIR:$PATH"

(
cd $GRASS_SRC
branches=`git branch -a --format='%(refname:short)'`

git fetch --all
git checkout master
# if upstream/master exists, assume it's https://github.com/OSGeo/grass.git's
# master branch
if echo "$branches" | grep -q '^upstream/master$'; then
	# merge OSGeo's master
	git merge upstream/master
else
	# merge origin/master (either OSGeo's or HuidaeCho's master)
	git merge origin/master
fi
# if origin/hcho exists, assume it's https://github.com/HuidaeCho/grass.git's
# hcho branch
if echo "$branches" | grep -q '^origin/hcho$'; then
	# use hcho because he's cool ;-)
	git checkout hcho
	# merge origin/hcho
	git merge origin/hcho
	# merge master already merged with upstream/master or origin/master
	git merge master
fi
myconfigure.sh
mymake.sh clean default

cd $GDAL_GRASS_SRC
myconfigure-gdal-grass.sh
make clean install

cd $GRASS_ADDONS_SRC
branches=`git branch -a --format='%(refname:short)'`

git fetch --all
git checkout master
# if upstream/master exists, assume it's
# https://github.com/OSGeo/grass-addons.git's master branch
if echo "$branches" | grep -q '^upstream/master$'; then
	# merge OSGeo's master
	git merge upstream/master
else
	# merge origin/master (either OSGeo's or HuidaeCho's master)
	git merge origin/master
fi
cd grass7
mkaddons.sh clean default

case "$1" in
-m|--mxe)
	cd $GRASS_SRC
	myconfigure.sh --mxe
	mymake.sh clean default
	copydocs.sh
	postcompile.sh
	package.sh
	switcharch.sh
	;;
esac
) > $GRASS_SRC/update.log 2>&1
