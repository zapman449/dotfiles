#!/bin/bash

# install gnu dircolors
# originaly from https://github.com/seebi/dircolors-solarized
# git repo: https://github.com/seebi/dircolors-solarized.git

if [ ! -d $1 ]; then
    # something bad happened
    echo "template directory $1 not found. Aborting"
    exit
fi

templates=$1

cd ~

rm -f .dir_colors
ln -s $templates/dircolors-solarized/dircolors.256dark .dir_colors
