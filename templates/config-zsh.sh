#!/bin/bash

# install zsh setup files into the home directory

if [ ! -d $1 ]; then
    # something bad happened
    echo "template directory $1 not found. Aborting"
    exit
fi

templates=$1

cd ~

rm -f .zlogin .zshenv .zshrc .aliases
ln -s $templates/zsh/.zlogin
ln -s $templates/zsh/.zshenv
ln -s $templates/zsh/.zshrc
ln -s $templates/zsh/.aliases
