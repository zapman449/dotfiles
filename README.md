dotfiles
========

dotfiles, refactored to use `stow`

## TL;DR:

First run: run `brew bundle --file=~/dotfiles/Brewfile` to get brew packages setup, then run `./setup.sh`.

Subsequent runs: run `./setup.sh` as it'll keep the brew world up-to-date.  (separated in first run to aid in triage of setup issues

## Other commands:

### disable accented character picker

NOTE: setup.sh does this now

macos, by default, on long-hold of a keyboard key, will show the character picker rather than repeat the character
until key release.  NOTE: you have to logout/log-back-in to the mac for this to take effect:

`defaults write -g ApplePressAndHoldEnabled -bool false`

On the off-chance you need to undo this, run the following (will still need logout/log-back-in):

`defaults write -g ApplePressAndHoldEnabled -bool true`

### Turn off "rearrange spaces"

`setup.sh` now automatically turns off "rearranging of Spaces"
