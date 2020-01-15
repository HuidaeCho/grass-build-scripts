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

grass_src=$1; shift
if [ ! -d $grass_src ]; then
	echo "$grass_src: No such directory"
	exit 1
fi

cd $grass_src
(
tmp=`realpath $0`; grass_build_scripts=`dirname $tmp`

# NOTE: add your options here
$grass_build_scripts/crosscompile.sh --update --package

arch=x86_64-w64-mingw32
version=`sed -n '/^INST_DIR[ \t]*=/{s/^.*grass//; p}' include/Make/Platform.make`
date=`date +%Y%m%d`
grass_zip=grass$version-$arch-$date.zip

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
 		rm -f $dir/grass*-$arch-*.zip
	fi
 	cp -a $grass_zip $dir
done
) > build_daily.log 2>&1
