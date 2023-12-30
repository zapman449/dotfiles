# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi
BREW_PREFIX=$(brew --prefix)
if [[ -r "${BREW_PREFIX}/opt/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source "${BREW_PREFIX}/opt/powerlevel10k/powerlevel10k.zsh-theme"
fi

#######################################################
# load Square specific zshrc; please don't change this bit.
#######################################################
source ~/Development/config_files/square/zshrc
#######################################################

# uncomment to automatically `bundle exec` common ruby commands
# if [[ -f "$SQUARE_HOME/config_files/square/bundler-exec.sh"]]; then
#   source $SQUARE_HOME/config_files/square/bundler-exec.sh
# fi

# load the aliases in config_files files (optional)
source ~/Development/config_files/square/aliases

###########################################
# Feel free to make your own changes below.
###########################################

cdpath=(. ~ ~/Development)
# shamelessly stolen from https://unix.stackexchange.com/questions/175108/when-using-zsh-tab-completion-ignore-cdpath-if-a-local-file-or-directory-matche/175203#175203
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

##############################################################################
# History Configuration
##############################################################################
# TODO: Make history depth infinite
# NOTE: ZSH can't make history infinite, because it holds all history in memory.  But a million entries is pretty close
HISTFILE=~/.zsh_history         # Where to save history to disk
HISTSIZE=1000000                # How many lines of history to keep in memory
SAVEHIST=1000000                # Number of history entries to save to disk
DIRSTACKSIZE=8                  # Depth of directory stack
# HISTDUP=erase                   # Erase duplicates in the history file
setopt  append_history          # Append history to the history file (no overwriting)
setopt  extended_history        # Write the history file in the ":start:elapsed;command" format.
setopt  share_history           # Share history across terminals
setopt  incappend_history       # Immediately append to the history file, not just when a term is killed
setopt  hist_expire_dups_first  # Expire duplicate entries first when trimming history.
setopt  hist_ignore_dups        # Don't record an entry that was just recorded again.
setopt  hist_ignore_space       # Don't record an entry that has a leading space
setopt  hist_find_no_dups       # Do not display a line previously found.
setopt  hist_reduce_blanks      # Remove superfluous blanks before recording entry.
setopt  hist_verify             # Don't execute immediately upon history expansion.
setopt  auto_pushd              # cd now pushes previous dir onto dirstack
setopt  pushd_silent            # don't print the dirstack on each cd
setopt  pushd_to_home           # naked pushd (or cd with autopushd) takes you home

[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.localaliases" ]] && source "$HOME/.localaliases"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

# Load version control information
autoload -Uz vcs_info

# Format the vcs_info_msg_0_ variable
# zstyle ':vcs_info:*' enable git formats "%s  %r/%S %b (%a) %m%u%c "
zstyle ':vcs_info:git*' formats "%a %b %m%u%c "
zstyle ':vcs_info:*' check-for-changes true

# export STARSHIP_CONFIG=/Users/jprice/.config/starship.toml
# eval "$(starship init zsh)"

# precmd() {
#     vcs_info
#     current_context=$(kubectl config current-context | awk 'BEGIN { FS = ":" } ; {$4 = substr($4,4,4) ; $6 = substr($6, 9) ; printf("%s-%s", $6, $4)}')
# }
#  
# setopt PROMPT_SUBST
# 
# # NOTE: single quotes around PROMPT strings are required, else vcs_info and others won't refresh.
# PROMPT='%T %F{green}%n@%m%f %F{red}${current_context}%f %F{yellow}${vcs_info_msg_0_}%f
#  %F{yellow}%#%F{red}%_%f '
# RPROMPT='%~ : %?'

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

if command -v kubectl >/dev/null ; then
    source <(kubectl completion zsh)
fi

if [[ -f /opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh ]]; then
    source /opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jprice/Development/google-cloud-sdk/path.zsh.inc' ]; then
    source '/Users/jprice/Development/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jprice/Development/google-cloud-sdk/completion.zsh.inc' ]; then
    source '/Users/jprice/Development/google-cloud-sdk/completion.zsh.inc'
fi

BREW_PREFIX=$(brew --prefix)
for gnu_dir in \
            ${BREW_PREFIX}/Cellar/gnu-sed/ \
            ${BREW_PREFIX}/Cellar/gnu-tar/ \
            ${BREW_PREFIX}/Cellar/gawk/ \
            ${BREW_PREFIX}/Cellar/findutils/ \
            ${BREW_PREFIX}/Cellar/coreutils/ \
            ; do
    
    # explicitly call the bsd versions here to avoid confusion
    version_dir=$(/usr/bin/find "${gnu_dir}" -maxdepth 2 -type d -name 'libexec' | /usr/bin/sort -n | /usr/bin/tail -1)
    final_dir=${version_dir}/gnubin
    # echo "version_dir is ${version_dir}"
    # If the value is not found in the array, ${my_array[(ie)foo] will
    # evaluate to the first index past the end of the array, so for a
    # 3-element array it would return 4.
    # https://unix.stackexchange.com/questions/411304/how-do-i-check-whether-a-zsh-array-contains-a-given-value/411307#411307
    if [[ ${path[(ie)$final_dir]} -gt ${#my_array} ]]; then
        PATH=${final_dir}:${PATH}
    fi
done
export PATH

if [[ -f /Users/jprice/Development/KubiScan/KubiScan.py ]] ; then
    alias kubiscan="python3 /Users/jprice/Development/KubiScan/KubiScan.py"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# include KREW in kubectl:
export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"

function manpdf() {
    man -t "${1}" | open -f -a Preview
}

source /opt/homebrew/Cellar/powerlevel10k/1.19.0/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export KUBE_EDITOR=/opt/homebrew/bin/nvim

if [[ -f ~/.fzf.zsh ]] ; then
    source ~/.fzf.zsh
fi

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if [[ -f "${HOME}/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi