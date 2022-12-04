#!/bin/sh
# This script switches the architecture before compiling GRASS GIS.

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

backup() {
	for i in \
		config.log \
		include/Make/Platform.make \
		include/Make/Doxyfile_arch_html \
		include/Make/Doxyfile_arch_latex \
		error.log \
	; do
		test -f $i && cp -a $i $i.$arch
	done
}

restore() {
	for i in \
		config.log \
		include/Make/Platform.make \
		include/Make/Doxyfile_arch_html \
		include/Make/Doxyfile_arch_latex \
		error.log \
	; do
		test -f $i.$arch && cp -a $i.$arch $i
	done
}

make=include/Make/Platform.make

if [ -f $make ]; then
	cur_arch=`sed -n '/^ARCH[ \t]*=/{s/^.*=[ \t]*//; p}' $make`
else
	cur_arch=
fi

case "$1" in
-h|--help)
	cat<<'EOT'
Usage: switcharch.sh [OPTIONS]

-h, --help     display this help message
    --mxe      switch to x86_64-w64-mingw32
	       (default: switch to the native architecture)
    --query    query the current architecture
EOT
	exit
	;;
--query)
	if [ -z "$cur_arch" ]; then
		echo "Current architecture undefined"
		exit 1
	fi
	echo $cur_arch
	exit
	;;
"")
	arch=`sh ./config.guess`
	;;
--mxe)
	arch=x86_64-w64-mingw32
	shift
	;;
*)
	echo "$1: Unknown option"
	exit
	;;
esac

arch_make=include/Make/Platform.make.$arch

if [ "$arch" = "$cur_arch" ]; then
	if [ -f $arch_make ]; then
		if diff $arch_make $make > /dev/null; then
			echo "$arch: Architecture already up to date"
		else
			restore
			echo "$arch: Architecture restored"
		fi
	else
		backup
		echo "$arch: Architecture backed up"
	fi
elif [ -f $arch_make ]; then
	restore
	echo "$arch: Architecture restored"
else
	echo "$arch: Architecture not configured"
	exit 1
fi
