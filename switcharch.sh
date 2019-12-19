#!/bin/sh
# This script switches the architecture before compiling GRASS GIS. It should
# be run from the root of the GRASS source code.
#
# Usage:
#	switcharch.sh		# for compiling native binaries
#	switcharch.sh --mxe	# for cross-compiling x86_64-w64-mingw32
#				# binaries using MXE
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
		test -f $i && cp -a $i $i.$ARCH
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
		test -f $i.$ARCH && cp -a $i.$ARCH $i
	done
}

MAKE=include/Make/Platform.make

if [ -f $MAKE ]; then
	CUR_ARCH=`sed -n '/^ARCH[ \t]*=/{s/^.*=[ \]*//; p}' $MAKE`
else
	CUR_ARCH=
fi

case "$1" in
-q|--query)
	if [ -z "$CUR_ARCH" ]; then
		echo "Current architecture undefined"
		exit 1
	fi
	echo $CUR_ARCH
	exit
	;;
""|-n|--native)
	ARCH=`sh ./config.guess`
	;;
-m|--mxe)
	ARCH=x86_64-w64-mingw32
	shift
	;;
*)
	ARCH=$1
	shift
	;;
esac

ARCH_MAKE=include/Make/Platform.make.$ARCH

if [ "$ARCH" = "$CUR_ARCH" ]; then
	if [ -f $ARCH_MAKE ]; then
		if diff $ARCH_MAKE $MAKE > /dev/null; then
			echo "$ARCH: Architecture already up to date"
		else
			restore
			echo "$ARCH: Architecture restored"
		fi
	else
		backup
		echo "$ARCH: Architecture backed up"
	fi
elif [ -f $ARCH_MAKE ]; then
	restore
	echo "$ARCH: Architecture restored"
else
	echo "$ARCH: Architecture not configured"
	exit 1
fi
