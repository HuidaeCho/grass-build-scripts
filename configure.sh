#!/bin/sh
# This script configures include/Make/Platform.make and other files for
# building GRASS GIS or gdal-grass.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}

build_arch=x86_64-pc-linux-gnu
target_arch=x86_64-w64-mingw32

case "$1" in
-h|--help)
	cat<<'EOT'
Usage: configure.sh [OPTIONS]

-h, --help        display this help message
-M, --mxe         configure GRASS for x86_64-w64-mingw32 binaries
	          (default: configure GRASS for native binaries)
-g, --gdal        configure gdal-grass for native binaries
-G, --gdal-mxe    configure gdal-grass for x86_64-w64-mingw32 binaries
EOT
	exit
	;;
"")
	cd $GRASS_SRC
	CFLAGS="-g -O2 -Wall" \
	CXXFLAGS="-g -O2 -Wall" \
	LDFLAGS="-lcurses" \
	./configure \
	--with-nls \
	--with-readline \
	--with-wxwidgets \
	--with-freetype-includes=$FREETYPE_INC \
	--with-bzlib \
	--with-postgres \
	--with-pthread \
	--with-openmp \
	--with-blas \
	--with-lapack \
	--with-geos \
	--with-netcdf \
	--with-pdal
	;;
-M|--mxe)
	cd $GRASS_SRC
	shared=$target_arch.shared
	mxe_bin=$MXE_DIR/usr/bin/$shared
	mxe_shared=$MXE_DIR/usr/$shared

	CC=$mxe_bin-gcc \
	CXX=$mxe_bin-g++ \
	CFLAGS="-g -O2 -Wall" \
	CXXFLAGS="-g -O2 -Wall" \
	AR=$mxe_bin-ar \
	RANLIB=$mxe_bin-ranlib \
	WINDRES=$mxe_bin-windres \
	PKG_CONFIG=$mxe_bin-pkg-config \
	./configure \
	--build=$build_arch \
	--host=$target_arch \
	--with-nls \
	--with-readline \
	--with-wxwidgets \
	--with-freetype-includes=$mxe_shared/include/freetype2 \
	--with-bzlib \
	--with-postgres \
	--with-pthread \
	--with-openmp \
	--with-blas \
	--with-lapack \
	--with-geos=$mxe_shared/bin/geos-config \
	--with-netcdf=$mxe_shared/bin/nc-config \
	--with-gdal=$mxe_shared/bin/gdal-config \
	--with-opengl=windows \
	--without-pdal
	;;
-g|--gdal)
	cd $GDAL_GRASS_SRC
	CXX="g++ -std=c++11" \
	./configure \
	--with-grass=$GRASS_SRC/dist.$build_arch \
	--with-autoload=$GDAL_PLUGINS_DIR
	;;
-G|--gdal-mxe)
	echo "gdal-grass doesn't support cross-compilation!"
	exit 1

	cd $GDAL_GRASS_SRC
	shared=$target_arch.shared
	mxe_bin=$MXE_DIR/usr/bin/$shared
	mxe_shared=$MXE_DIR/usr/$shared

	CC=$mxe_bin-gcc \
	CXX=$mxe_bin-g++ \
	CFLAGS="-g -O2 -Wall" \
	CXXFLAGS="-g -O2 -Wall" \
	AR=$mxe_bin-ar \
	RANLIB=$mxe_bin-ranlib \
	./configure \
	--with-gdal=$mxe_bin-gdal-config \
	--with-grass=$GRASS_SRC/dist.$target_arch \
	--with-autoload=$GRASS_SRC/dist.$target_arch/lib
	;;
*)
	echo "$1: Unknown option"
	exit 1
	;;
esac

case "$1" in
""|-M|--mxe)
	arch=`sed -n '/^ARCH[ \t]*=/{s/^.*=[ \t]*//; p}' include/Make/Platform.make`
	for i in \
		config.log \
		include/Make/Platform.make \
		include/Make/Doxyfile_arch_html \
		include/Make/Doxyfile_arch_latex \
	; do
		cp -a $i $i.$arch
	done
	;;
esac
