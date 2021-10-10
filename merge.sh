#!/bin/sh
# This script merges remote branches.

# see if we're inside the root of the GRASS source code
if [ ! -f SUBMITTING ]; then
	echo "Please run this script from the root of the GRASS source code"
	exit 1
fi
if [ ! -d .git ]; then
	echo "not a git repository"
	exit 1
fi

branches=`git branch -a --format='%(refname:short)'`

git fetch --all
git checkout main
# if upstream/main exists, assume it's OSGeo's main branch
if echo "$branches" | grep -q '^upstream/main$'; then
	# merge OSGeo's main
	git merge upstream/main
else
	# merge origin/main (either OSGeo's or HuidaeCho's main)
	git merge origin/main
fi
# if origin/hcho exists, assume it's HuidaeCho's hcho branch
if echo "$branches" | grep -q '^origin/hcho$'; then
	# use hcho because he's cool ;-)
	git checkout hcho
	# merge origin/hcho
	git merge origin/hcho
	# merge main already merged with upstream/main or origin/main
	git merge main
fi
# if upstream/grass7 exists, assume it's OSGeo's grass-addons repo
if echo "$branches" | grep -q '^upstream/grass7'; then
	git checkout grass7
	git merge upstream/grass7
fi
