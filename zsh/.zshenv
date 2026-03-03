path=( ~/bin ~/.local/bin )
path+=( /opt/homebrew/bin /opt/homebrew/sbin )
path+=( /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin )
path+=( /System/Cryptexes/App/usr/bin ) # MacOS security tooling, probably not particularly useful?

export PATH

BREW_PREFIX=$(brew --prefix)
eval "$(${BREW_PREFIX}/bin/brew shellenv)"

