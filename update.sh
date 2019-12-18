#!/bin/sh
set -e

(
cd ~/usr/grass/grass
git checkout master
git fetch --all
git merge upstream/master
git checkout hcho
git merge master
../myconfigure.sh
../mymake.sh clean default

if [ "$1" = "mxe" ]; then
	../myconfigure.sh mxe
	../mymake.sh clean default
	../copydocs.sh
	../mkfontcap.sh G:/grass
	../switcharch.sh
fi

cd ~/usr/local/src/gdal-grass-3.0.2
../myconfigure-gdal-grass.sh
make clean
make
make install

cd ~/usr/grass/grass-addons
git fetch --all
git merge upstream/master
cd grass7
../../myaddons.sh clean default
) > ~/usr/grass/update.log 2>&1
