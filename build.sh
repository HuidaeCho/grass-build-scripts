#!/bin/sh
# This script builds GRASS GIS using other scripts and MXE.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

merge=0
addons=0
gdal=0
mxe=0
package=0
for opt; do
	case "$opt" in
	-h|--help)
		cat<<'EOT'
Usage: build.sh [OPTIONS]

-h, --help       display this help message
-m, --merge      merge the upstream repositories
-a, --addons     build addons
-g, --gdal       build gdal-grass
-M, --mxe        cross-compile using MXE
-p, --package    package the build as grass{VERSION}-x86_64-w64-mingw32-{YYYYMMDD}.zip
EOT
		exit
		;;
	-m|--merge)
		merge=1
		;;
	-a|--addons)
		addons=1
		;;
	-g|--gdal)
		gdal=1
		;;
	-M|--mxe)
		mxe=1
		;;
	-p|--package)
		package=1
		;;
	*)
		"$opt: Unknown option"
		exit 1
		;;
	esac
done

export PATH="$(dirname $(realpath $0)):$PATH"

echo "Started compilation: `date`"
echo

[ $merge -eq 1 ] && merge.sh
configure.sh
make.sh clean default

if [ $gdal -eq 1 ]; then
	[ $merge -eq 1 ] && merge.sh --gdal
	configure.sh --gdal
	make.sh --gdal clean install
fi

if [ $addons -eq 1 ]; then
	[ $merge -eq 1 ] && merge.sh --addons
	make.sh --addons clean default
fi

if [ $mxe -eq 1 ]; then
	configure.sh --mxe
	make.sh clean default

	# gdal-grass doesn't support cross-compilation!
#	if [ $gdal -eq 1 ]; then
#		configure.sh --gdal-mxe
#		make.sh --gdal clean install
#	fi

	[ $addons -eq 1 ] && make.sh --addons clean default

	copydocs.sh
	copydlls.sh
	mkbats.sh
	switcharch.sh
fi

[ $package -eq 1 ] && package.sh

echo
echo "Completed compilation: `date`"
