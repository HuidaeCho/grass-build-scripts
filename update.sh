#!/bin/sh
set -e
. ~/.grassbuildrc

PATH="$GRASS_BUILD_DIR:$PATH"

(
cd $GRASS_SRC
git checkout master
git fetch --all
git merge upstream/master
git checkout hcho
git merge master
myconfigure.sh
mymake.sh clean default

if [ "$1" = "mxe" ]; then
	myconfigure.sh mxe
	mymake.sh clean default
	copydocs.sh
	postcompile.sh D:/opt/grass C:/Python38
	switcharch.sh
fi

cd $GDAL_GRASS_SRC
myconfigure-gdal-grass.sh
make clean install

cd $GRASS_ADDONS_SRC
git fetch --all
git merge upstream/master
cd grass7
myaddons.sh clean default
) > $GRASS_SRC/update.log 2>&1
