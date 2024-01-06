#!/bin/bash

set -euo pipefail

if command -v stow >/dev/null ; then
    # noop
    echo >/dev/null
else
    echo "please install stow, probably with brew"
    exit 1
fi

# ensure the "stow dir" is correct
cd "${HOME}/dotfiles"

echo "---> updating git repo"
git pull

echo "---> installing tools (phase 1)"
stow tmux
stow wezterm
stow zsh

echo "---> installing tools (phase 2)"
# need to set target dir for nvim so it doesn't take over the whole ~/.config hierarchy
[[ ! -d "${HOME}/.config/nvim" ]] && mkdir -p "${HOME}/.config/nvim"
stow nvim --target="${HOME}/.config/nvim"

[[ ! -d "${HOME}/.config/starship" ]] && mkdir -p "${HOME}/.config/starship"
stow starship --target="${HOME}/.config/starship"
