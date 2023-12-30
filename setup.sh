#!/bin/bash

set -euo pipefail

# ensure the "stow dir" is correct
cd "${HOME}/dotfiles"

stow tmux
stow wezterm
stow zsh

# need to set target dir for nvim so it doesn't take over the whole ~/.config hierarchy
[[ ! -d "${HOME}/.config/nvim" ]] && mkdir -p "${HOME}/.config/nvim"
stow nvim --target="${HOME}/.config/nvim"
