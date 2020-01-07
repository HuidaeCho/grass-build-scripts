#!/bin/sh
# This script switches the architecture before compiling GRASS GIS. It should
# be run from the root of the GRASS source code.
#
# Usage:
#	switcharch.sh		# switch the current architecture to native
#	switcharch.sh --mxe	# switch the current architecture to x86_64-w64-mingw32
#	switcharch.sh --query	# query the current architecture

set -e
. ${GRASSBUILDRC-~/.grassbuildrc}
cd $GRASS_SRC

backup() {
	for i in \
		myconfigure.log \
		config.log \
		include/Make/Platform.make \
		include/Make/Doxyfile_arch_html \
		include/Make/Doxyfile_arch_latex \
		mymake.log \
		error.log \
	; do
		test -f $i && cp -a $i $i.$arch
	done
}

restore() {
	for i in \
		myconfigure.log \
		config.log \
		include/Make/Platform.make \
		include/Make/Doxyfile_arch_html \
		include/Make/Doxyfile_arch_latex \
		mymake.log \
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
-q|--query)
	if [ -z "$cur_arch" ]; then
		echo "Current architecture undefined"
		exit 1
	fi
	echo $cur_arch
	exit
	;;
""|-n|--native)
	arch=`sh ./config.guess`
	;;
-m|--mxe)
	arch=x86_64-w64-mingw32
	shift
	;;
*)
	arch=$1
	shift
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
