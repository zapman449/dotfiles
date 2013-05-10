#!/bin/bash

# script to setup dotfiles.  Dunno if I should stash this in git or in
# dropbox yet.

homebase=~/programs/dotfiles
templates=$homebase/templates
directories=$homebase/directories

for config in $templates/config*.sh ; do
    /bin/bash $config $templates
done

cd ~
for dir in $directories ; do
    if [ -d $d ]; then
        mydir=`basename $dir`
        if [ -d ~/${mydir} ]; then
            rm -rf ~/${mydir}
	    ln -s $dir
	fi
    fi
done
