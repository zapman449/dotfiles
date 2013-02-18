#!/bin/bash

# install vim dotfiles

if [ ! -d $1 ]; then
    # something bad happened
    echo "template directory $1 not found. Aborting"
    exit
fi

templates=$1

cd ~

[ -L .config/terminator/config ] && rm -fr .config/terminator/config
[ -d .config/terminator/config ] && rm -fr .config/terminator/config
ln -s $templates/terminator/config
