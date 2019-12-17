#!/bin/sh
make \
MODULE_TOPDIR=$HOME/usr/grass/grass/dist.x86_64-pc-linux-gnu \
LIBREDWGLIBPATH=-L$HOME/usr/local/lib64 \
LIBREDWGINCPATH=-I$HOME/usr/local/include \
"$@" > myaddons.log 2>&1
