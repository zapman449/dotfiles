path=( ~/bin ~/.local/bin )
path+=( /opt/homebrew/bin /opt/homebrew/sbin )

# brief digression into brew config stuff
BREW_PREFIX=$(brew --prefix)
eval "$(${BREW_PREFIX}/bin/brew shellenv)"

# get various gnu utils early in $PATH
path+=( \
    ${BREW_PREFIX}/opt/coreutils/libexec/gnubin \
    ${BREW_PREFIX}/opt/findutils/libexec/gnubin \
    ${BREW_PREFIX}/opt/gnu-sed/libexec/gnubin \
    ${BREW_PREFIX}/opt/gnu-tar/libexec/gnubin \
    ${BREW_PREFIX}/opt/gawk/libexec/gnubin \
)

path+=( /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin )
path+=( /System/Cryptexes/App/usr/bin ) # MacOS security tooling, probably not particularly useful?

export PATH
