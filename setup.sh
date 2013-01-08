#!/bin/bash

# script to setup dotfiles.  Dunno if I should stash this in git or in
# dropbox yet.

homebase=~/programs/dotfiles
templates=$homebase/templates

for config in $templates/config*.sh ; do
    /bin/bash $config $templates
done
