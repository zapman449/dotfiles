dotfiles
========

dotfiles, refactored to use `stow`

`brew install stow` to get started, presuming a mac (though most everything here should work the same on linux)

Other brew formulas:

```
brew install awscli bat ca-certificates coreutils eza fd findutils fzf gawk gnu-sed gnu-tar \
             jq neovim readline ripgrep shellcheck starship stow tmux tree-sitter watch \
             wezterm yq zsh zsh-syntax-highlighting
```

## Other commands:

### disable accented character picker
macos, by default, on long-hold of a keyboard key, will show the character picker rather than repeat the character
until key release.  NOTE: you have to logout/log-back-in to the mac for this to take effect:

`defaults write -g ApplePressAndHoldEnabled -bool false`

On the off-chance you need to undo this, run the following (will still need logout/log-back-in):

`defaults write -g ApplePressAndHoldEnabled -bool true`
