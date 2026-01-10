# enable profiling (NOTE: also requires `zprof` to be called at the bottom
# zmodload zsh/zprof

#######################################################
# load Square specific zshrc; please don't change this bit.
#######################################################
DISABLE_AUTO_NVM_USE=true
if [[ -f ~/Development/config_files/square/zshrc ]]; then
    source ~/Development/config_files/square/zshrc
fi
#######################################################

# uncomment to automatically `bundle exec` common ruby commands
# if [[ -f "$SQUARE_HOME/config_files/square/bundler-exec.sh"]]; then
#   source $SQUARE_HOME/config_files/square/bundler-exec.sh
# fi

# load the aliases in config_files files (optional)
if [[ -f ~/Development/config_files/square/aliases ]]; then
    source ~/Development/config_files/square/aliases
fi

###########################################
# Feel free to make your own changes below.
###########################################

# ghostty integration
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  autoload -Uz -- "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
  ghostty-integration
  unfunction ghostty-integration
fi

BREW_PREFIX=$(brew --prefix)

export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

cdpath=(. ~ ~/Development)
# shamelessly stolen from https://unix.stackexchange.com/questions/175108/when-using-zsh-tab-completion-ignore-cdpath-if-a-local-file-or-directory-matche/175203#175203
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

##############################################################################
# History Configuration
##############################################################################
# TODO: Make history depth infinite
# NOTE: ZSH can't make history infinite, because it holds all history in memory.  But a million entries is pretty close
HISTFILE=~/.zsh_history        # Where to save history to disk
HISTSIZE=1000000               # How many lines of history to keep in memory
SAVEHIST=1000000               # Number of history entries to save to disk
DIRSTACKSIZE=8                 # Depth of directory stack
# HISTDUP=erase                  # Erase duplicates in the history file
setopt append_history          # Append history to the history file (no overwriting)
setopt complete_aliases        # tab complete commands even behind aliases
setopt extended_history        # Write the history file in the ":start:elapsed;command" format.
setopt share_history           # Share history across terminals
setopt inc_append_history      # Immediately append to the history file, not just when a term is killed
setopt hist_expire_dups_first  # Expire duplicate entries first when trimming history.
setopt hist_ignore_dups        # Don't record an entry that was just recorded again.
setopt hist_ignore_space       # Don't record an entry that has a leading space
setopt hist_find_no_dups       # Do not display a line previously found.
setopt hist_reduce_blanks      # Remove superfluous blanks before recording entry.
setopt hist_verify             # Don't execute immediately upon history expansion.
setopt auto_pushd              # cd now pushes previous dir onto dirstack
setopt pushd_silent            # don't print the dirstack on each cd
setopt pushd_to_home           # naked pushd (or cd with autopushd) takes you home

[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.localaliases" ]] && source "$HOME/.localaliases"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

# Load version control information
autoload -Uz vcs_info

# Format the vcs_info_msg_0_ variable
# zstyle ':vcs_info:*' enable git formats "%s  %r/%S %b (%a) %m%u%c "
zstyle ':vcs_info:git*' formats "%a %b %m%u%c "
zstyle ':vcs_info:*' check-for-changes true

# setup partial word completion (completion from middle of word)
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
autoload -Uz compinit
compinit

# make ctrl-w break words on slash as well as space
my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word

bindkey "^[^[[C" forward-word		# option-right-arrow goes forward word (I think this is alt on a PC keyboard)
bindkey "^[^[[D" backward-word		# option-left-arrow goes backwards word (I think this is alt on a PC keyboard)
bindkey '^z' push-line-or-edit

# bring in kubectl completions - lazy, first invocation pays the penalty
if [[ $commands[kubectl] ]]; then
    kubectl() {
        unfunction kubectl
        source <(command kubectl completion zsh)
        kubectl "$@"
    }
fi

# if completion for aws in zsh is installed, setup aws for lazy loading of completion config
if [[ -f /opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh ]]; then
    aws() {
        unfunction aws
        source /opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh
        aws "$@"
    }
fi

# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/Users/jprice/Development/google-cloud-sdk/path.zsh.inc' ]; then
#    source '/Users/jprice/Development/google-cloud-sdk/path.zsh.inc'
#fi

# The next line enables shell command completion for gcloud.
#if [ -f '/Users/jprice/Development/google-cloud-sdk/completion.zsh.inc' ]; then
#    source '/Users/jprice/Development/google-cloud-sdk/completion.zsh.inc'
#fi

# get various gnu utils early in $PATH (note in zsh $path and $PATH are tied together)
path=(
    ${BREW_PREFIX}/opt/coreutils/libexec/gnubin
    ${BREW_PREFIX}/opt/findutils/libexec/gnubin
    ${BREW_PREFIX}/opt/gnu-sed/libexec/gnubin
    ${BREW_PREFIX}/opt/gnu-tar/libexec/gnubin
    ${BREW_PREFIX}/opt/gawk/libexec/gnubin
    $path
)
export PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

function manpdf() {
    man -t "${1}" | open -f -a Preview
}

export KUBE_EDITOR=/opt/homebrew/bin/nvim

# use fzf for history searching
if [[ -f ~/.fzf.zsh ]] ; then
    source ~/.fzf.zsh
fi

if [[ -f ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f "${HOME}/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

if [[ -f "${HOME}/.ripgreprc" ]]; then
    export RIPGREP_CONFIG_PATH=~/.ripgreprc
fi

export NODE_EXTRA_CA_CERTS=/opt/homebrew/etc/ca-certificates/cert.pem
export COREPACK_NPM_REGISTRY=https://artifactory.global.square/artifactory/api/npm/square-npm/
export COREPACK_INTEGRITY_KEYS=0

# report profiling data (NOTE: also requires `zmodload zsh/zprof` to be called at the top

### The lines in this section are added automatically by salt. Do not modify. ###
#Default shell configs
######
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# zprof
