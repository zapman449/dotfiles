#!/bin/bash

# install tmux config file

if [ ! -d $1 ]; then
    # something bad happened
    echo "template directory $1 not found. Aborting"
    exit
fi

templates=$1

cd ~

[ -L .tmux.conf ] && rm -f .tmux.conf
[ -f .tmux.conf ] && rm -f .tmux.conf
ln -s ${templates}/tmux/.tmux.conf .tmux.conf
