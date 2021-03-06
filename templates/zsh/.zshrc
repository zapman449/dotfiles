# .zshrc.  This file keeps most of the fun zsh settings.  It gets read by
# any interactive zsh session (logins), so it should be concerned with
# things for you actually type into.

###############################################################################
# set prompts

# source ~/programs/git/zsh-git-prompt/zshrc.sh

# PROMPT='%@ %B%n@%m%b $(git_super_status) ${CHEF_FULL:-} %~
PROMPT='%@ %B%n@%m%b %~
%(!.# .->)'

#RPROMPT=' %~'     # prompt for right side of screen

###############################################################################
# use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s

umask 077

###############################################################################
# filename completion suffixes to ignore
fignore=(.o .c~ .old .pyc)

###############################################################################
# search path for the cd command
cdpath=(. ~ ~/programs/git)

# found here: http://superuser.com/questions/265547/zsh-cdpath-and-autocompletion
#zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %B%d%b        # bold

###############################################################################
# Where to look for autoloaded function definitions

#fpath=( /usr/local/share/zsh/$ZSH_VERSION/functions )

# Autoload all shell functions from all directories in $fpath that have
# the executable bit on (the executable bit is not necessary, but gives
# you an easy way to stop the autoloading of a particular shell function).

autoload $^fpath/*(N:t)
#autoload $^fpath/*(N.x:t)

###############################################################################
# bigger shell functions to autoload

#autoload zed
#autoload run-help

###############################################################################
# Set history settings
if (( ! EUID )); then
    HISTFILE=~/.zsh.history_root
else
    HISTFILE=~/.zsh.history
fi

# stolen from here: http://www.lowlevelmanager.com/2012/04/zsh-history-extend-and-persist.html
# and tweaked
# .zshrc
## History
setopt APPEND_HISTORY          # append rather than overwrite history file.
HISTSIZE=1200                  # lines of history to maintain memory
SAVEHIST=3000                  # lines of history to maintain in history file.
setopt HIST_EXPIRE_DUPS_FIRST  # allow dups, but expire old ones when I hit HISTSIZE
setopt EXTENDED_HISTORY        # save timestamp and runtime information

###############################################################################
# Set options
setopt   autocd autolist autopushd autoresume cdablevars clobber completeinword
setopt   correct correctall extendedglob globdots histignoredups longlistjobs
setopt   mailwarning menucomplete pushdminus pushdsilent pushdtohome rcquotes 
#setopt   share_history
unsetopt bgnice recexact


###############################################################################
# watch for logins/logouts
#   watch=(all)
#   WATCHFMT='%n %a %l from %m at %t.'
#   LOGCHECK=0

# make home and end keys do THE RIGHT THING:
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line

# vi or emacs key bindings.
bindkey -v
#bindkey -e

# override the silly default 'in vi mode, up arrow takes you to the beginning of the line' BS
[[ -z "$terminfo[cuu1]" ]] || bindkey -M viins "$terminfo[cuu1]" up-line-or-history
[[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" up-line-or-history
[[ "$terminfo[kcuu1]" == "O"* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-history
[[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" down-line-or-history
[[ "$terminfo[kcud1]" == "O"* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-history

# fix arrows in vi insert mode: (if needed)
# bindkey -M viins '^[[D' vi-backward-char \
#                 '^[[C' vi-forward-char \
#                 '^[[A' up-line-or-history \
#                 '^[[B' down-line-or-history

# add incremental history search
bindkey '^R' history-incremental-search-backward

# rebind ^a to beginning of line and ^e to end of line:
bindkey '^A' vi-beginning-of-line
bindkey '^E' vi-end-of-line

###############################################################################
# The following lines were added by compinstall
# run 'compinstall' or if that fails:
# /usr/local/bin/zsh /usr/local/share/zsh/4.0.1/functions/compinstall

zstyle ':completion:*' completer _expand _complete _approximate
zstyle ':completion:*' glob 1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '' 'r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 1
zstyle :compinstall filename '/home/jprice/.zshrc'
[[ -z $fpath[(r)$_compdir] ]] && fpath=($fpath $_compdir)

autoload -U compinit
compinit -u
# End of lines added by compinstall

zstyle -s ':completion:*:hosts' hosts _ssh_config
[[ -r ~/.ssh/config ]] && _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p'))
zstyle ':completion:*:hosts' hosts $_ssh_config

###############################################################################
# Setup dircolors to be sane
#if [[ -f $HOME/.dir_colors ]]; then
#    eval `dircolors $HOME/.dir_colors`
#fi

###############################################################################
# source other files of note:  particularly .aliases and .zsh-styles

#filelist=( ~/.aliases ~/.zsh-styles ~/.ssh_logins ~/.aliases.local )

export PATH=${HOME}/programs/git/homebrew/bin:${PATH}

for file in .aliases .zsh-styles .ssh_logins .aliases.local ; do
   if [[ -f $HOME/$file ]]; then
      . $file
   fi
done

