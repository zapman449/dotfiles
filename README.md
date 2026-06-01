dotfiles
========

dotfiles, refactored to use `stow`

## TL;DR:

First run: run `brew bundle --file=~/dotfiles/Brewfile` to get brew packages setup, then run `./setup.sh`.

Subsequent runs: run `./setup.sh` as it'll keep the brew world up-to-date.  (separated in first run to aid in triage of setup issues

## Other commands:

### disable accented character picker
macos, by default, on long-hold of a keyboard key, will show the character picker rather than repeat the character
until key release.  NOTE: you have to logout/log-back-in to the mac for this to take effect:

`defaults write -g ApplePressAndHoldEnabled -bool false`

On the off-chance you need to undo this, run the following (will still need logout/log-back-in):

`defaults write -g ApplePressAndHoldEnabled -bool true`

### git config

Run:
* `git config --global alias.unadd 'restore --staged'` - adds alias for "git unadd"

### Turn off "rearrange spaces"

* System Preferences:
  * Desktop & Dock
    * Scroll to "Mission Control"
      * turn off "Automatically rearrange Spaces based on most recent use"
