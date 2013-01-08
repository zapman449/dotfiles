#!/bin/bash

# install vim dotfiles

if [ ! -d $1 ]; then
    # something bad happened
    echo "template directory $1 not found. Aborting"
    exit
fi

templates=$1

cd ~

[ -L .gvimrc ] && rm -f .gvimrc
[ -f .gvimrc ] && rm -f .gvimrc
[ -L .vimrc ] && rm -f .vimrc
[ -f .vimrc ] && rm -f .vimrc
[ -L .vim ] && rm -fr .vim
[ -d .vim ] && rm -fr .vim
ln -s $templates/vim/.gvimrc
ln -s $templates/vim/.vimrc
ln -s $templates/vim/.vim
