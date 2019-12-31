#!/bin/sh
# This script configures gdal-grass plugins.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GDAL_GRASS_SRC

CXX="g++ -std=c++11" \
./configure \
--with-grass=$GRASS_SRC/dist.x86_64-pc-linux-gnu \
--with-autoload=$GDAL_PLUGINS_DIR \
> myconfigure.log 2>&1
