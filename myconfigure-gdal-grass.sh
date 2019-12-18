#!/bin/sh
set -e
. ~/.grassbuildrc
cd $GDAL_GRASS_SRC

CXX="g++ -std=c++11" \
./configure \
--with-autoload=$GDAL_PLUGINS_DIR \
--with-grass=$GRASS_SRC/dist.x86_64-pc-linux-gnu \
> myconfigure.log
