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

and ... massive nerd font list? do I actually need all this mess:
```
brew tap homebrew/cask-fonts
brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
```
