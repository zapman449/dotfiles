#!/bin/bash

set -euo pipefail

# ensure the "stow dir" is correct
cd "${HOME}/dotfiles"

command -v git >/dev/null || { echo "please install git"; exit 1; }

echo "---> updating git repo"
git pull

command -v brew >/dev/null || { echo "please install homebrew"; exit 1; }

brew update
brew bundle --file=~/dotfiles/Brewfile

command -v stow >/dev/null || { echo "please install stow"; exit 1; }

echo "---> installing tools (phase 1)"
stow ripgrep
stow tmux
stow wezterm
stow zsh

if [[ -L ~/.fzf.zsh ]]; then
    rm ~/.fzf.zsh
fi

echo "---> installing tools (phase 2)"
# need to set target dir for nvim so it doesn't take over the whole ~/.config hierarchy
[[ ! -d "${HOME}/.config/nvim" ]] && mkdir -p "${HOME}/.config/nvim"
stow nvim --target="${HOME}/.config/nvim"

[[ ! -d "${HOME}/.config/starship" ]] && mkdir -p "${HOME}/.config/starship"
stow starship --target="${HOME}/.config/starship"

[[ ! -d "${HOME}/bin" ]] && mkdir -p "${HOME}/bin"
stow bin --target="${HOME}/bin"

UNAME=$(uname)
if [[ "${UNAME}" == "Darwin" ]]; then
    stow_ghostty_dir="${HOME}/Library/Application Support/com.mitchellh.ghostty"
    [[ ! -d "${stow_ghostty_dir}" ]] && mkdir -p "${stow_ghostty_dir}"
    stow ghostty --target="${stow_ghostty_dir}"

    stow glow "--target=${HOME}/Library/Preferences/glow"
fi
