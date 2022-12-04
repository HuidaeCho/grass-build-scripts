#!/bin/sh
# This script builds GRASS GIS using other scripts and MXE.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

grass_build_scripts=$(dirname $(realpath $0))

merge=0
addons=0
mxe=0
package=0
for opt; do
	case "$opt" in
	-h|--help)
		cat<<'EOT'
Usage: build.sh [OPTIONS]

-h, --help       display this help message
    --merge      merge the upstream repositories
    --addons     build addons
    --mxe        cross-compile using MXE
    --package    package the build as grass{VERSION}-x86_64-w64-mingw32-{YYYYMMDD}.zip
EOT
		exit
		;;
	--merge)
		merge=1
		;;
	--addons)
		addons=1
		;;
	--mxe)
		mxe=1
		;;
	--package)
		package=1
		;;
	esac
done

export PATH="$grass_build_scripts:$PATH"

echo "Started compilation: `date`"
echo

if [ $merge -eq 1 ]; then (
	cd $GRASS_SRC
	merge.sh
) fi
configure.sh
make.sh clean default
(
cd $GDAL_GRASS_SRC
configure-gdal-grass.sh
make clean install
)

if [ $addons -eq 1 ]; then
	if [ $merge -eq 1 ]; then (
		cd $GRASS_ADDONS_SRC
		merge.sh
	) fi
	mkaddons.sh clean default
fi

if [ $mxe -eq 1 ]; then
	configure.sh --mxe
	make.sh clean default
	(
	cd $GDAL_GRASS_SRC
	configure-gdal-grass.sh --mxe
	make clean install
	)
	if [ $addons -eq 1 ]; then
		mkaddons.sh clean default
	fi

	copydocs.sh
	copydlls.sh
	mkbats.sh
	switcharch.sh
fi

if [ $package -eq 1 ]; then
	package.sh
fi

echo
echo "Completed compilation: `date`"
