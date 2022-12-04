#!/bin/sh
# This script merges upstream branches.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

branch=main

case "$1" in
-h|--help)
	cat<<'EOT'
Usage: merge.sh [OPTIONS]

-h, --help      display this help message
    --addons    merge GRASS addons (default: GRASS)
    --gdal      merge gdal-grass
EOT
"")
	cd $GRASS_SRC
	;;
--addons)
	cd $GRASS_ADDONS_SRC
	branch=grass8
	;;
--gdal)
	cd $GDAL_GRASS_SRC
	;;
*)
	echo "$1: Unknown option"
	exit 1
	;;
esac

upstream=`git remote -v | sed '/git@github.com:OSGeo/!d; s/\t.*//'`

git fetch --all --prune
git checkout $branch
git rebase $upstream/$branch
