# enable profiling (NOTE: also requires `zprof` to be called at the bottom
# zmodload zsh/zprof

# ghostty integration
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  autoload -Uz -- "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
  ghostty-integration
  unfunction ghostty-integration
fi

# force uniqueness on all entries in path/PATH
typeset -U path

# cache the given path (see /etc/zprofile call to /usr/libexec/path_helper)
provided_path=( $path )

# normally we shouldn't clear $PATH and restart, but this lets us take full
# control, and have the system provided stuff at the end.
# Also normally, we'd set $PATH in .zshenv, but the path_helper stuff up-ends that
path=( ~/bin ~/.local/bin )

if [[ -f /opt/homebrew/bin/brew ]]; then
    path+=( /opt/homebrew/bin /opt/homebrew/sbin )
elif [[ -f /usr/local/bin/brew ]]; then
    path+=( /usr/local/bin /usr/local/sbin )
fi

# brief digression into brew config stuff
if (( $+commands[brew] )); then
   eval "$(brew shellenv)"
else
    echo "WARNING: brew not found in PATH, this will cause problems"
fi

# get various gnu utils early in $PATH
path+=( 
    ${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin \
    ${HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin \
    ${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin \
    ${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin \
    ${HOMEBREW_PREFIX}/opt/gawk/libexec/gnubin \
)

path+=( /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin )
path+=( ~/go/bin )

# re-add the system provided stuff at the end
path+=( $provided_path )
unset provided_path

##############################################################################
# History Configuration
##############################################################################
# NOTE: ZSH can't make history infinite, because it holds all history in memory.  But a million entries is pretty close
HISTFILE=~/.zsh_history        # Where to save history to disk
HISTSIZE=1000000               # How many lines of history to keep in memory
SAVEHIST=1000000               # Number of history entries to save to disk
DIRSTACKSIZE=8                 # Depth of directory stack
setopt append_history          # Append history to the history file (no overwriting)
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

cdpath=(. ~ ~/Development)
# shamelessly stolen from
# https://unix.stackexchange.com/questions/175108/when-using-zsh-tab-completion-ignore-cdpath-if-a-local-file-or-directory-matche/175203#175203
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# setup partial word completion (completion from middle of word)
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# make ctrl-w break words on slash as well as space
my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word

bindkey "^[f"  forward-word     # meta-f aka option-right-arrow aka alt-right-arrow
bindkey "^[b" backward-word     # meta-b aka option-left-arrow aka alt-left-arrow
bindkey '^z' push-line-or-edit

# bring in kubectl completions. opt for eager-load for interactive speed
if (( $+commands[kubectl] )); then
    source <(kubectl completion zsh)
fi

# if completion for aws in zsh is installed, setup aws for lazy loading of completion config
if [[ -f /opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh ]]; then
    aws() {
        unfunction aws
        source /opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh
        aws "$@"
    }
fi

function manpdf {
    man -t "${1}" | open -f -a Preview
}

# ~/bin/vim is a symlink to "correct vim".  Currently it's neovim 0.12
export EDITOR=~/bin/vim

[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.localaliases" ]] && source "$HOME/.localaliases"

# use fzf for history searching
if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

if [[ -f ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

[[ -f "${HOME}/.cargo/env" ]] && source "$HOME/.cargo/env"

if [[ -f "${HOME}/.ripgreprc" ]]; then
    export RIPGREP_CONFIG_PATH=~/.ripgreprc
fi

if (( $+commands[starship] )) && [[ -f ~/.config/starship/starship.toml ]]; then
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
    eval "$(starship init zsh)"
fi

if [[ -f ~/.zshrc ]] && [[ ! -L ~/.zshrc ]]; then
    echo "WARNING: ~/.zshrc is no longer a symlink"
fi

# report profiling data (NOTE: also requires `zmodload zsh/zprof` to be called at the top
# zprof
