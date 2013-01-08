#!/bin/bash

# install fonts (specifically Inconsolata...
#     http://levien.com/type/myfonts/inconsolata.html
# )

if [ ! -d $1 ]; then
    # something bad happened
    echo "template directory $1 not found. Aborting"
    exit
fi

templates=$1

cd ~

[ -L .fonts ] && rm -f .fonts
[ -d .fonts ] && rm -f .fonts
ln -s $templates/fonts .fonts
