# .zshrc.  This file keeps most of the fun zsh settings.  It gets read by
# any interactive zsh session (logins), so it should be concerned with
# things for you actually type into.

###############################################################################
# set prompts

PROMPT='%@ %B%n@%m%b
%(!.# .->)'

RPROMPT=' %~'     # prompt for right side of screen

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
cdpath=(. ~)

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
HISTSIZE=1000
if (( ! EUID )); then
    HISTFILE=~/.zsh.history_root
else
    HISTFILE=~/.zsh.history
fi
SAVEHIST=1000

###############################################################################
# Set options
setopt   autocd autolist autopushd autoresume cdablevars clobber completeinword
setopt   correct correctall extendedglob globdots histignoredups longlistjobs
setopt   mailwarning menucomplete pushdminus pushdsilent pushdtohome rcquotes 
setopt   share_history
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
compinit
# End of lines added by compinstall

###############################################################################
# Setup dircolors to be sane
if [[ -f $HOME/.dir_colors ]]; then
    eval `dircolors $HOME/.dir_colors`
fi

###############################################################################
# source other files of note:  particularly .aliases and .zsh-styles

#filelist=( ~/.aliases ~/.zsh-styles ~/.ssh_logins ~/.aliases.local )

for file in .aliases .zsh-styles .ssh_logins .aliases.local ; do
   if [[ -f $HOME/$file ]]; then
      . $file
   fi
done

