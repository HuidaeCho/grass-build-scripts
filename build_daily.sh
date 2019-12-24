#!/bin/sh
# This script is meant to be run by Task Scheduler.
#
# To build the latest
# /usr/local/src/grass-buildw-scripts/build_daily.sh /usr/local/src/grass
#
# To build the latest and copy it to ~/archive and /www/software
# /usr/local/src/grass-build-scripts/build_daily.sh /usr/local/src/grass
#	~/archive /www/software
#
# To build the latest and copy it to ~/archive and /www/software, but
# delete any previous packages from /www/software leaving the latest only
# /usr/local/src/grass-build-scripts/build_daily.sh /usr/local/src/grass
#	~/archive -/www/software

set -e

if [ $# -lt 1 ]; then
	echo "Usage: build_daily.sh /path/to/grass/source [/deploy/path1 /deploy/paty2 ...]"
	exit 1
fi

GRASS_SRC=$1; shift
if [ ! -d $GRASS_SRC ]; then
	echo "$GRASS_SRC: No such directory"
	exit 1
fi

cd $GRASS_SRC
(
tmp=`dirname $0`; GRASS_BUILD_SCRIPTS=`realpath $tmp`

# NOTE: add your options here
$GRASS_BUILD_SCRIPTS/crosscompile.sh --update --package

ARCH=x86_64-w64-mingw32
VERSION=`sed -n '/^INST_DIR[ \t]*=/{s/^.*grass//; p}' include/Make/Platform.make`
DATE=`date +%Y%m%d`
GRASS_ZIP=grass$VERSION-$ARCH-$DATE.zip

for dir; do
	delete=0
	case "$dir" in
	-*)
		delete=1
		dir=`echo $dir | sed 's/^-//'`
		;;
	esac
 	test -d $dir || mkdir -p $dir
	if [ $delete -eq 1 ]; then
 		rm -f $dir/grass*-$ARCH-*.zip
	fi
 	cp -a $GRASS_ZIP $dir
done
) > build_daily.log 2>&1
