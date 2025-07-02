PATH=~/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/System/Cryptexes/App/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin/usr/local/opt/fzf/bin
export PATH

BREW_PREFIX=$(brew --prefix)
eval "$(${BREW_PREFIX}/bin/brew shellenv)"


# Setting PATH for Python 3.13
# The original version is saved in .zprofile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
# export PATH
