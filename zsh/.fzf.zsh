# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}${BREW_PREFIX}/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${BREW_PREFIX}/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${BREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
